_: {
  flake.modules.common."misc" = {
    pkgs,
    inputs,
    config,
    lib,
    ...
  }: {
    environment.persistence = lib.mkIf config.features.impermanence.enable {
      "/persist".users.${config.user.name}.directories = [
        ".mozilla/firefox"
        ".config/chromium"
        ".gemini"
      ];
    };

    # NixOS
    services.udev.packages = [pkgs.headsetcontrol];

    environment.systemPackages = with pkgs; [
      mesa-demos
      steam-run
      glib
      alsa-utils
      headsetcontrol
      qmk-udev-rules
    ];

    fonts.packages = with pkgs; [
      nerd-fonts.monaspace
      google-fonts
    ];

    # Home Manager
    home-manager.users.${config.user.name} = {
      home = {
        packages = with pkgs; [
          masterpdfeditor4
          libreoffice-qt
          kdePackages.filelight
          wl-clipboard
          piper
          pavucontrol
          firefox
          keepass
          ungoogled-chromium
          qbittorrent
          wineWow64Packages.stable
          winetricks
          winboat
          crosspipe
          gemini-cli
        ];

        sessionPath = [
          "$HOME/.local/bin"
        ];
      };

      fonts.fontconfig.enable = true;
    };
  };
}
