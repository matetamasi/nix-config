_: {
  flake.modules.common."home-manager" = {inputs, ...}: {
    home-manager = {
      useUserPackages = true;
      sharedModules = [inputs.plasma-manager.homeModules.plasma-manager];
    };
  };
}
