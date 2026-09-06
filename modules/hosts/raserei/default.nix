{inputs, ...}: {
  flake.nixosConfigurations.raserei = inputs.nixpkgs-stable.lib.nixosSystem {
    system = "x86_64-linux";
    modules =
      (with inputs; [
        agenix.nixosModules.default
        disko.nixosModules.default
        home-manager-stable.nixosModules.home-manager
        impermanence.nixosModules.impermanence
        angrr.nixosModules.angrr
      ])
      ++ (with inputs.self.modules.raserei; [
        hardware-configuration
        disko
        ssh
        wireguard
      ])
      ++ (with inputs.self.modules.common; [
        cli
        gc
        git
        home-manager
        impermanence
        networking
        core
        nixvim
        secrets
        starship
        users
        zfs
        zsh
      ])
      ++ [
        ({config, ...}: {
          _module.args = {inherit inputs;};

          age.secrets = {
            matetamasi-password = {
              file = ../../../secrets/raserei-matetamasi-password.age;
              owner = "root";
              group = "root";
            };
            root-password = {
              file = ../../../secrets/raserei-root-password.age;
              owner = "root";
              group = "root";
            };
          };
          networking = {
            hostName = "raserei";
            hostId = "8d9adac9";
          };
          features.impermanence.enable = false;

          system.stateVersion = "26.05";
          home-manager.users.${config.user.name}.home.stateVersion = "26.05";

          users.users = {
            root.hashedPasswordFile = config.age.secrets.root-password.path;
            ${config.user.name}. hashedPasswordFile = config.age.secrets.matetamasi-password.path;
          };

          boot.loader.systemd-boot.enable = true;
          boot.loader.efi.canTouchEfiVariables = true;

          services = {
            openssh = {
              enable = true;
              openFirewall = true;
              ports = [22460];
              settings = {
                PasswordAuthentication = false;
                KbdInteractiveAuthentication = false;
                PermitRootLogin = "no";
                AllowUsers = ["matetamasi"];
                PerSourcePenalties = "authfail:3600s";
              };
            };
            ddclient = {
              enable = true;
              interval = "1min";
              protocol = "dyndns2";
              server = "update.dedyn.io";
              username = "tamasi.dev";
              passwordFile = "/home/matetamasi/tamasidev_token";
              domains = ["tamasi.dev"];
              usev4 = "webv4, webv4=checkip.dedyn.io";
            };
          };
        })
      ];
  };
}
