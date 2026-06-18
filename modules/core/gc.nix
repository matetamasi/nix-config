_: {
  flake.modules.nixos."gc" = {
    config,
    lib,
    inputs,
    pkgs,
    ...
  }: let
    retentionPolicy = {
      keep-booted-system = true;
      keep-current-system = true;
      keep-since = "14d";
      keep-n-per-bucket = [
        {
          bucket-window = "1d";
          bucket-amount = 60;
        }
        {
          bucket-window = "30d";
          bucket-amount = 60;
        }
      ];
    };
  in {
    nix = {
      gc = {
        automatic = true;
        dates = "weekly";
      };
      optimise = {
        automatic = true;
        dates = ["weekly"];
      };
    };

    services.angrr = {
      enable = true;
      package = inputs.angrr.packages.${pkgs.stdenv.hostPlatform.system}.angrr;
      timer = {
        enable = true;
        dates = "weekly";
      };
      settings = {
        profile-policies = {
          system =
            {
              profile-paths = ["/nix/var/nix/profiles/system"];
            }
            // retentionPolicy;
          home-manager =
            {
              profile-paths = [
                "~/.local/state/nix/profiles/home-manager"
                "/nix/var/nix/profiles/per-user/*/home-manager"
              ];
            }
            // retentionPolicy;
          user =
            {
              profile-paths = [
                "~/.local/state/nix/profiles/profile"
                "/nix/var/nix/profiles/per-user/*/profile"
              ];
            }
            // retentionPolicy;
        };
      };
    };
  };
}
