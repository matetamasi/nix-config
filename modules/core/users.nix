_: {
  flake.modules.common."users" = {
    pkgs,
    config,
    lib,
    ...
  }: {
    options.user.name = lib.mkOption {
      type = lib.types.str;
      default = "matetamasi";
      description = "The primary user's name";
    };

    config = {
      users = {
        mutableUsers = false;
        users.${config.user.name} = {
          isNormalUser = true;
          description = "Tamási Máté";
          extraGroups = ["networkmanager" "wheel"];
          shell = pkgs.zsh;
        };
      };
      home-manager.users.${config.user.name} = {
        osConfig,
        config,
        ...
      }: {
        home = {
          username = "${osConfig.user.name}";
          homeDirectory = "/home/${config.home.username}";
        };
      };
    };
  };
}
