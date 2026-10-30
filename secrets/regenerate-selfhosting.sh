#!/usr/bin/env nix
#! nix shell nixpkgs#bash nixpkgs#age nixpkgs#openssl nixpkgs#authelia --command bash
# Regenerates the random selfhosting secrets and encrypts them to the
# recipients listed in secrets.nix. Plaintext never touches the disk.
# caddy-env.age and authelia-users.age hold values only you know; edit them
# with agenix instead.
set -euo pipefail

cd "$(dirname "$0")"
authelia_nix=../modules/selfhosting/authelia.nix

# Encrypts stdin to the recipients listed for $1 in secrets.nix
enc() {
  age -R <(nix eval --raw --file secrets.nix "\"$1\".publicKeys" \
    --apply 'builtins.concatStringsSep "\n"') -o "$1"
}

for s in authelia-jwt-secret authelia-session-secret authelia-storage-encryption-key authelia-oidc-hmac-secret; do
  openssl rand -hex 64 | tr -d '\n' | enc "$s.age"
done

openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:4096 2>/dev/null | enc authelia-oidc-issuer-key.age

# Headscale's OIDC client secret: plaintext for headscale, digest for Authelia
secret=$(openssl rand -hex 32)
printf '%s' "$secret" | enc headscale-oidc-client-secret.age
digest=$(authelia crypto hash generate pbkdf2 --variant sha512 --password "$secret" | sed -n 's/^Digest: //p')
unset secret
sed -i "s|client_secret = \".*\";|client_secret = \"$digest\";|" "$authelia_nix"

# DKIM: encrypt the private key, keep the public key for DNS
key=$(openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 2>/dev/null)
printf '%s\n' "$key" | enc dkim-key.age
dkim_pub=$(printf '%s\n' "$key" | openssl pkey -pubout | grep -v -- ----- | tr -d '\n')
unset key

cat <<EOF
Regenerated and encrypted:
  authelia-{jwt-secret,session-secret,storage-encryption-key,oidc-hmac-secret,oidc-issuer-key}.age
  headscale-oidc-client-secret.age
  dkim-key.age

Updated client_secret digest in $authelia_nix

Set the mail._domainkey TXT record in deSEC (and README.md) to:
  v=DKIM1; k=rsa; p=$dkim_pub

If Authelia has already run with the old keys: the old storage encryption key
is needed to read its database (authelia storage encryption change-key), or
delete /var/lib/authelia-main/db.sqlite3. A new session secret logs everyone out.
EOF
