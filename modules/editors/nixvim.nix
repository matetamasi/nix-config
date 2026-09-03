_: {
  flake.modules.common."nixvim" = {
    inputs,
    config,
    ...
  }: {
    home-manager.users.${config.user.name} = {
      imports = [
        inputs.nixvim.homeModules.nixvim
        ./_nixvim/nixvim.nix
      ];
      home.sessionVariables.EDITOR = "nvim";

      programs.nixvim.nixpkgs.source = inputs.nixpkgs;
    };
  };
}
