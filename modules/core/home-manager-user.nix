{...}: {
  flake.modules.nixos."home-manager-user" = {
    lib,
    config,
    ...
  }: {
    home-manager.users.${config.user.name} = {
      osConfig,
      config,
      ...
    }: {
      home.username = "${osConfig.user.name}";
      home.homeDirectory = "/home/${config.home.username}";
      home.stateVersion = "23.11";
    };
  };
}
