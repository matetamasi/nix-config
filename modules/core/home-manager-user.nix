{
  ...
}: {
  home-manager.users.matetamasi = {config, ...}: {
    home.username = "matetamasi";
    home.homeDirectory = "/home/${config.home.username}";
    home.stateVersion = "23.11";
  };
}
