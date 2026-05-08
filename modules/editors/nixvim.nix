{...}: {
  flake.modules.nixos."nixvim" = {inputs, ...}: {
    home-manager.users.matetamasi = {
      imports = [
        inputs.nixvim.homeModules.nixvim
        ./_nixvim/nixvim.nix
      ];
    };
  };
}
