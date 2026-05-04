{
  nixvim,
  ...
}: {
  home-manager.users.matetamasi = {
    imports = [
      nixvim.homeModules.nixvim
      ./_nixvim/nixvim.nix
    ];
  };
}
