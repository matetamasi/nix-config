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
        ddclient
        user-auth
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

          networking = {
            hostName = "raserei";
            hostId = "8d9adac9";
          };
          features.impermanence.enable = false;

          system.stateVersion = "26.05";
          home-manager.users.${config.user.name}.home.stateVersion = "26.05";

          boot.loader = {
            systemd-boot.enable = true;
            efi.canTouchEfiVariables = true;
          };
        })
      ];
  };
}
