{
  zen-browser-pkg,
  ...
}: {
  home-manager.users.matetamasi = {
    home.packages = [
      zen-browser-pkg
    ];

    # Default applications
    xdg.mimeApps = {
      enable = true;

      defaultApplications = {
        "text/html" = "zen-beta.desktop";
        "x-scheme-handler/http" = "zen-beta.desktop";
        "x-scheme-handler/https" = "zen-beta.desktop";
        "x-scheme-handler/about" = "zen-beta.desktop";
        "x-scheme-handler/unknown" = "zen-beta.desktop";
      };
    };
  };
}
