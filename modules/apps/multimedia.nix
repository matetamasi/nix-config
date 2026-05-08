{...}: {
  flake.modules.nixos."multimedia" = {
    pkgs,
    config,
    lib,
    ...
  }: {
    environment.persistence."/persist".users.matetamasi.directories = lib.mkIf config.features.impermanence.enable [
      ".config/Signal"
      ".config/vesktop"
      ".config/Caprine" # Messenger client
      ".config/Slack"
      ".config/spotify"
      ".config/Element"
    ];

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
  };
}
