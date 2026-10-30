_: {
  flake.modules.selfhosting."authelia" = {
    config,
    lib,
    ...
  }: let
    instance = config.services.authelia.instances.main;
    stateDir = "/var/lib/authelia-main";

    secret = file: {
      inherit file;
      owner = instance.user;
      inherit (instance) group;
    };
  in {
    age.secrets = {
      authelia-jwt-secret = secret ../../secrets/authelia-jwt-secret.age;
      authelia-session-secret = secret ../../secrets/authelia-session-secret.age;
      authelia-storage-encryption-key = secret ../../secrets/authelia-storage-encryption-key.age;
      authelia-oidc-hmac-secret = secret ../../secrets/authelia-oidc-hmac-secret.age;
      authelia-oidc-issuer-key = secret ../../secrets/authelia-oidc-issuer-key.age;
      authelia-users = secret ../../secrets/authelia-users.age;
    };

    services.authelia.instances.main = {
      enable = true;
      secrets = with config.age.secrets; {
        jwtSecretFile = authelia-jwt-secret.path;
        sessionSecretFile = authelia-session-secret.path;
        storageEncryptionKeyFile = authelia-storage-encryption-key.path;
        oidcHmacSecretFile = authelia-oidc-hmac-secret.path;
        oidcIssuerPrivateKeyFile = authelia-oidc-issuer-key.path;
      };

      settings = {
        theme = "auto";
        default_2fa_method = "totp";
        log.level = "info";
        server.address = "tcp://127.0.0.1:9091/";

        totp.issuer = "tamasi.dev";
        webauthn.display_name = "Authelia";

        authentication_backend = {
          file = {
            path = config.age.secrets.authelia-users.path;
            watch = false;
          };
          password_reset.disable = true;
          password_change.disable = true;
        };

        session.cookies = [
          {
            domain = "tamasi.dev";
            authelia_url = "https://auth.tamasi.dev";
          }
        ];

        storage.local.path = "${stateDir}/db.sqlite3";

        notifier.smtp = {
          address = "smtp://127.0.0.1:25";
          sender = "Authelia <authelia@tamasi.dev>";
          identifier = "auth.tamasi.dev";
          disable_require_tls = true;
        };

        access_control = {
          default_policy = "deny";
          rules = [
          ];
        };

        identity_providers.oidc = {
          authorization_policies.tailnet = {
            default_policy = "deny";
            rules = [
              {
                policy = "two_factor";
                subject = "group:tailnet";
              }
            ];
          };

          clients = [
            {
              client_id = "headscale";
              client_name = "Headscale";
              client_secret = "$pbkdf2-sha512$310000$HIb10S3.DgcbAKRPq8cXwg$A8NvT/ltke7DVHoEtyYS1MobwH2BitNyQFZ2ihfajriel7OY3is5Mpr7Ky09pa1vwdSrer4ohA.0gR4ji9O9yA";
              public = false;
              authorization_policy = "tailnet";
              require_pkce = true;
              pkce_challenge_method = "S256";
              redirect_uris = ["https://headscale.tamasi.dev/oidc/callback"];
              scopes = ["openid" "profile" "email" "groups"];
              response_types = ["code"];
              grant_types = ["authorization_code"];
              access_token_signed_response_alg = "none";
              userinfo_signed_response_alg = "none";
              token_endpoint_auth_method = "client_secret_basic";
            }
          ];
        };
      };
    };

    systemd.services.authelia-main = {
      after = ["postfix.service"];
      wants = ["postfix.service"];
    };
  };
}
