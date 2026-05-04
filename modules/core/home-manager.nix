{
  pkgs-stable,
  nixvim,
  zen-browser-pkg,
  plasma-manager,
  ...
}: {
  home-manager = {
    useUserPackages = true;
    sharedModules = [plasma-manager.homeModules.plasma-manager];
    extraSpecialArgs = {
      inherit nixvim;
      inherit zen-browser-pkg;
      inherit pkgs-stable;
    };
  };
}
