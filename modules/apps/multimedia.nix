{inputs, ...}: {
  flake.modules.nixos."multimedia" = {
    pkgs,
    config,
    lib,
    ...
  }: {
    environment.persistence."/persist".users.${config.user.name}.directories = lib.mkIf config.features.impermanence.enable [
      ".config/Signal"
      ".config/vesktop"
      ".config/Caprine" # Messenger client
      ".config/Slack"
      ".config/spotify"
      ".config/Element"
    ];

    home-manager.users.${config.user.name} = {
      programs.spotify-player = {
        enable = true;
        package = pkgs.spotify-player.overrideAttrs (old: {
          cargoBuildFeatures = (old.cargoBuildFeatures or old.buildFeatures or []) ++ ["pixelate"];
        });
        settings = {
          enable_notify = false;
          cover_img_pixels = 48;
          cover_img_length = 16;
          cover_img_width = 8;
          enable_audio_visualization = true;
        };
      };

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
