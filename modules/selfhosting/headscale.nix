_: {
  flake.modules.selfhosting."headscale" = {
    config,
    lib,
    ...
  }: {
    age.secrets.headscale-oidc-client-secret = {
      file = ../../secrets/headscale-oidc-client-secret.age;
      owner = config.services.headscale.user;
      group = config.services.headscale.group;
    };

    networking.hosts."127.0.0.1" = ["auth.tamasi.dev" "headscale.tamasi.dev"];

    services.headscale = {
      enable = true;
      address = "127.0.0.1";
      port = 8080;
      settings = {
        server_url = "https://headscale.tamasi.dev";

        dns = {
          magic_dns = true;
          base_domain = "ts.tamasi.dev";
          override_local_dns = true;
          nameservers.global = ["9.9.9.9" "149.112.112.112" "2620:fe::fe" "2620:fe::9"];
          extra_records = [
            {
              name = "auth.tamasi.dev";
              type = "A";
              value = "100.64.0.1";
            }
          ];
        };

        oidc = {
          issuer = "https://auth.tamasi.dev";
          client_id = "headscale";
          client_secret_path = config.age.secrets.headscale-oidc-client-secret.path;
          scope = ["openid" "profile" "email" "groups"];
          pkce = {
            enabled = true;
            method = "S256";
          };
        };
      };
    };

    systemd.services.headscale = {
      after = ["authelia-main.service" "caddy.service"];
      wants = ["authelia-main.service" "caddy.service"];
    };

    services.tailscale = {
      enable = true;
      openFirewall = true;
    };
  };
}
