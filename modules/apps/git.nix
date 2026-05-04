{
  ...
}: {
  home-manager.users.matetamasi = {
    programs.git = {
      enable = true;
      settings.user = {
        email = "matetamasi@protonmail.com";
        name = "Tamási Máté";
      };
      signing.format = "openpgp";
    };

    programs.delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        features = "navigation side-by-side";
      };
    };
  };
}
