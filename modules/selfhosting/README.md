# Selfhosting

Runs on `raserei`.

| Service   | Address                  | Reachable from |
|-----------|--------------------------|----------------|
| Authelia  | `auth.tamasi.dev`        | internet       |
| Headscale | `headscale.tamasi.dev`   | internet       |
| private sites | `<name>.tamasi.dev` | tailnet only, behind Authelia |

Caddy terminates TLS with a single `*.tamasi.dev` certificate (deSEC DNS-01),
so private subdomains never appear in certificate transparency logs. Private
sites are only answered when the client address is in the tailnet range;
everything else gets the connection aborted. Headscale's MagicDNS points the
private names at this host's tailnet IP. Headscale logins go through Authelia
(OIDC). Only members of the `tailnet` group may join. Postfix only listens on
loopback, signs outgoing mail with DKIM and sends Authelia's notification and
verification mails.

Adding a private site takes three entries, each with a commented example:

- a vhost in `caddy.nix`
- an `access_control` rule in `authelia.nix`
- a DNS record in `headscale.nix` (`dns.extra_records`)

## One-time setup

### 1. Secrets to fill in

Generated already (random, encrypted to raserei's host key): `authelia-*`
(except users), `headscale-oidc-client-secret`, `dkim-key`.

Placeholders you have to replace (`rm` the file, then `agenix -e <file>`):

- `caddy-env.age`: `DESEC_TOKEN=<token>`. The token needs to be able to edit
  `tamasi.dev` records. The ddclient token works but a separate one is better.
- `authelia-users.age`:

  ```yaml
  users:
    matetamasi:
      disabled: false
      displayname: "Máté Tamási"
      email: matetamasi@protonmail.com
      password: "$argon2id$..." # nix run nixpkgs#authelia -- crypto hash generate argon2
      groups: [admins, tailnet]
  ```

### 2. DNS records (deSEC)

| Name                         | Type  | Value |
|------------------------------|-------|-------|
| `auth`                       | CNAME | `tamasi.dev.` |
| `headscale`                  | CNAME | `tamasi.dev.` |
| `tamasi.dev`                 | TXT   | `"v=spf1 a -all"` |
| `mail._domainkey`            | TXT   | `"v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA8WbiGXgebE6jmTwHNiq3AFQkWRA6c5bYMl/IYyvrmLDPD4VzBByFsb/vOeDXaou3eeYblJIDw32cDkYzeWHtUxCE+cYYRC5fpBv1OEHyUTvMG6xL9Sre5lzDnKZLxsERajmRC3LYCPZriU9ScMtO7ARpJxjccMsFDLLfD97gDqn9Jk/O6gerQC97MPcKuuHiEN0dg3ly9bpOHbwWzUL9p8sekH3oEkL+ugeIucH01l/lHBZJqyXzxq/Y8rmtI9cC7h2JbNDdiX3oCOguWyLUy1oWg4X6qEjGi8ChIrsOyEzMRSCHppsl2puLqJFZ4E9t6JAcI07sSoQzXNzhtQEF3wIDAQAB"` |
| `_dmarc`                     | TXT   | `"v=DMARC1; p=quarantine; rua=mailto:matetamasi@protonmail.com"` |

The DKIM value is longer than 255 characters. deSEC accepts it as one quoted
string and splits it automatically. If it complains, split it into two quoted
strings.

### 3. Router

Forward TCP 80, TCP 443 and UDP 443 to raserei. Tailscale also works without
port forwarding (it falls back to DERP relays), but forwarding UDP 41641 gives
direct connections.

### 4. Mail deliverability

By default postfix delivers mail directly. On a residential connection this
usually fails: ISPs often block outbound port 25, dynamic IPs are listed on
Spamhaus PBL, and reverse DNS doesn't match. Test with
`echo test | sendmail -f authelia@tamasi.dev you@example.com` and
`journalctl -u postfix`. If mail doesn't arrive, use a relay (any SMTP
provider, e.g. Brevo, Mailgun, or Proton Mail SMTP submission if tamasi.dev is
added to your Proton account):

uncomment the relay block at the end of `mail.nix`, set `relayhost`, and
create `secrets/smtp-relay.age` with `[smtp.example.com]:587 user:password`.
If the relay sends with its own envelope domain, add its SPF `include:` to the
SPF record.

### 5. Joining the tailnet

After switching:

```sh
# Register raserei itself first so it gets 100.64.0.1
sudo headscale users create raserei
sudo headscale preauthkeys create --user <id from `headscale users list`>
sudo tailscale up --login-server https://headscale.tamasi.dev --accept-dns=false --authkey <key>
tailscale ip -4   # must match the extra_records in headscale.nix
```

Other devices: `tailscale up --login-server https://headscale.tamasi.dev`, then
open the printed URL. You're sent to Authelia, and the headscale user is
created from your Authelia account. Set up TOTP/WebAuthn on first login. The
verification code is sent by mail, so step 4 has to work first.
