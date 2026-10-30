let
  nixos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEWYs+vS0rRamy642AnzwIhAzV3RPYQBz95CPeelHaeX";
  raserei = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGipGj7Ba+vWwTbFNCuKzcIns7CQYmA79CAtGSKp/WSk";
in {
  "eduroam.env.age".publicKeys = [nixos];
  "raserei-matetamasi-password.age".publicKeys = [raserei];
  "raserei-root-password.age".publicKeys = [raserei];
  "raserei-wg.age".publicKeys = [raserei];
  "frammenwerken-wg.age".publicKeys = [nixos];
  "spotify-client-id.age".publicKeys = [nixos];

  # Selfhosting (raserei)
  "caddy-env.age".publicKeys = [raserei];
  "authelia-jwt-secret.age".publicKeys = [raserei];
  "authelia-session-secret.age".publicKeys = [raserei];
  "authelia-storage-encryption-key.age".publicKeys = [raserei];
  "authelia-oidc-hmac-secret.age".publicKeys = [raserei];
  "authelia-oidc-issuer-key.age".publicKeys = [raserei];
  "authelia-users.age".publicKeys = [raserei];
  "headscale-oidc-client-secret.age".publicKeys = [raserei];
  "dkim-key.age".publicKeys = [raserei];
  # Only needed when selfhosting.mail.relayHost is set
  "smtp-relay.age".publicKeys = [raserei];
}
