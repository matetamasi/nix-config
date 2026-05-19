{...}: {
  flake.modules.nixos."nixvim" = {
    inputs,
    config,
    ...
  }: {
    home-manager.users.${config.user.name} = {
      imports = [
        inputs.nixvim.homeModules.nixvim
        ./_nixvim/nixvim.nix
      ];
    };
  };
}
