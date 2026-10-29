_: {
  flake.modules.common."multimedia" = {
    pkgs,
    config,
    lib,
    ...
  }: {
    environment.persistence = lib.mkIf config.features.impermanence.enable {
      "/persist".users.${config.user.name}.directories = [
        ".config/Signal"
        ".config/vesktop"
        ".config/Caprine" # Messenger client
        ".config/Slack"
        ".config/spotify"
        ".config/Element"
      ];
    };

    age.secrets.spotify = {
      file = ../../secrets/spotify-client-id.age;
      owner = config.user.name;
    };

    home-manager.users.${config.user.name} = {
      programs = {
        spotify-player = {
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
            client_id_command = {
              command = "cat";
              args = [config.age.secrets.spotify.path];
            };
          };
        };
      };

      home = {
        packages = with pkgs; [
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

        file.".config/zathura/zathurarc".text = ''
          map <C-i> recolor
        '';

        sessionVariables = {
          SIGNAL_PASSWORD_STORE = "gnome-libsecret";
        };
      };
      xdg.desktopEntries.signal = {
        name = "Signal";
        exec = "signal-desktop --password-store=gnome-libsecret %U";
        icon = "signal-desktop";
        terminal = false;
        categories = ["Network" "InstantMessaging" "Chat"];
        mimeType = ["x-scheme-handler/sgnl" "x-scheme-handler/signalcaptcha"];
      };
    };
  };
}
