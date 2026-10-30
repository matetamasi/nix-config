_: {
  flake.modules.selfhosting."caddy" = {
    config,
    lib,
    pkgs,
    ...
  }: {
    age.secrets.caddy-env = {
      file = ../../secrets/caddy-env.age;
      owner = "caddy";
      group = "caddy";
    };

    services.caddy = {
      enable = true;
      package = pkgs.caddy.withPlugins {
        plugins = ["github.com/caddy-dns/desec@v1.1.0"];
        hash = "sha256-HrLRezw+q5+dRdJS662686n7xsImSxNb3UqlSo61R8E=";
      };
      email = "mate@tamasi.dev";
      openFirewall = true;
      environmentFile = config.age.secrets.caddy-env.path;

      globalConfig = ''
        acme_dns desec {
          token {env.DESEC_TOKEN}
        }
      '';

      virtualHosts = {
        "*.tamasi.dev".extraConfig = "abort";

        "auth.tamasi.dev".extraConfig = "reverse_proxy 127.0.0.1:9091";
        "headscale.tamasi.dev".extraConfig = "reverse_proxy 127.0.0.1:8080";
      };
    };
  };
}
