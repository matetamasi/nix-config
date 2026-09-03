{inputs, ...}: {
  flake.nixosConfigurations.raserei = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules =
      (with inputs; [
        agenix.nixosModules.default
        disko.nixosModules.default
        home-manager.nixosModules.home-manager
        impermanence.nixosModules.impermanence
      ])
      ++ (with inputs.self.modules.raserei; [
        hardware-configuration
        disko
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
          networking.hostName = "raserei";
          features.impermanence.enable = false;

          system.stateVersion = "26.05";
          home-manager.users.${config.user.name}.stateVersion = "26.05";
        })
      ];
  };
}
