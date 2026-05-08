{...}: {
  flake.modules.nixos."teams" = {
    pkgs,
    config,
    lib,
    ...
  }: {
    environment.persistence."/persist".users.matetamasi.directories = lib.mkIf config.features.impermanence.enable [
      ".local/share/teams-for-linux-profile"
    ];

    home-manager.users.matetamasi = {config, ...}: let
      teams-icons = pkgs.runCommand "teams-custom-icons" {nativeBuildInputs = [pkgs.librsvg];} ''
        mkdir -p $out/share/icons/hicolor/512x512/apps
        rsvg-convert -w 512 -h 512 ${../../resources/icons/teams/teams-for-linux-BME.svg} -o $out/share/icons/hicolor/512x512/apps/teams-for-linux-BME.png
        rsvg-convert -w 512 -h 512 ${../../resources/icons/teams/teams-for-linux-MOK.svg} -o $out/share/icons/hicolor/512x512/apps/teams-for-linux-MOK.png

        mkdir -p $out/share/icons/hicolor/scalable/apps
        cp ${../../resources/icons/teams/teams-for-linux-BME.svg} $out/share/icons/hicolor/scalable/apps/teams-for-linux-BME.svg
        cp ${../../resources/icons/teams/teams-for-linux-MOK.svg} $out/share/icons/hicolor/scalable/apps/teams-for-linux-MOK.svg
      '';

      teams-for-linux-profiles = pkgs.teams-for-linux.overrideAttrs (oldAttrs: {
        desktopItems = [
          (pkgs.makeDesktopItem {
            name = "teams-for-linux-bme";
            exec = "teams-for-linux --class=teams-for-linux-mok --user-data-dir=${config.home.homeDirectory}/.local/share/teams-for-linux-profile/BME --appIcon=${teams-icons}/share/icons/hicolor/512x512/apps/teams-for-linux-BME.png %U";
            icon = "teams-for-linux-BME";
            startupWMClass = "teams-for-linux-bme";
            desktopName = "BME Teams";
            comment = "Budapesti Műszaki Egyetem Teams";
            categories = [
              "Network"
              "InstantMessaging"
              "Chat"
            ];
            mimeTypes = ["x-scheme-handler/msteams"];
          })
          (pkgs.makeDesktopItem {
            name = "teams-for-linux-mok";
            exec = "teams-for-linux --class=teams-for-linux-mok --user-data-dir=${config.home.homeDirectory}/.local/share/teams-for-linux-profile/MOK --appIcon=${teams-icons}/share/icons/hicolor/512x512/apps/teams-for-linux-MOK.png %U";
            icon = "teams-for-linux-MOK";
            startupWMClass = "teams-for-linux-bme";
            desktopName = "MÖK Teams";
            comment = "MÖK Egyesület Teams";
            categories = [
              "Network"
              "InstantMessaging"
              "Chat"
            ];
            mimeTypes = ["x-scheme-handler/msteams"];
          })
        ];
      });
    in {
      home.packages = [
        teams-for-linux-profiles
        teams-icons
      ];
    };
  };
}
