{inputs, ...}: {
  flake.nixosConfigurations.nixos = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = with inputs.self.modules.nixos; [
      inputs.nixos-hardware.nixosModules.framework-16-7040-amd
      inputs.agenix.nixosModules.default
      inputs.disko.nixosModules.default
      inputs.home-manager.nixosModules.home-manager
      inputs.impermanence.nixosModules.impermanence

      {
        _module.args = {inherit inputs;};
        features.impermanence.enable = true;
      }

      browser
      development
      disko
      gaming
      git
      hardware-configuration
      home-manager
      home-manager-user
      hyprland
      impermanence
      misc
      multimedia
      networking
      nixos
      nixvim
      plasma
      secrets
      starship
      teams
      users
      virtualization
      zfs
      zsh
    ];
  };
}
