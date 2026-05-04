{
  pkgs,
  ...
}: {
  home-manager.users.matetamasi = {
    home.packages = with pkgs; [
      ncspot
      spotify
      gimp
      kdePackages.kcolorchooser
      haruna
      zathura
      vesktop
      element-desktop
      krita
      signal-desktop
      slack
      caprine-bin
    ];

    home.file.".config/zathura/zathurarc".text = ''
      map <C-i> recolor
    '';
  };
}
