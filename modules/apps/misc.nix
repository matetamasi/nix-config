{...}: {
  flake.modules.nixos."misc" = {
    pkgs,
    inputs,
    config,
    lib,
    ...
  }: {
    environment.persistence."/persist".users.matetamasi.directories = lib.mkIf config.features.impermanence.enable [
      ".mozilla/firefox"
      ".config/chromium"
    ];

    # NixOS
    services.udev.packages = [pkgs.headsetcontrol];

    environment.systemPackages = with pkgs; [
      zfs-prune-snapshots
      ripgrep
      file
      vim
      alejandra
      nix-output-monitor
      git
      tree
      coreutils-full
      pciutils
      lshw
      mesa-demos
      fastfetch
      steam-run
      glib
      alsa-utils
      headsetcontrol
      htop-vim
      qmk-udev-rules
      libsecret
      inputs.agenix.packages.${pkgs.system}.default

      # For herbstluftwm - TODO: move to separate file, import conditionally
      pamixer
      arandr
      xbacklight
      playerctl
      scrot
      networkmanagerapplet
      xinit
      rofi
      polybarFull
    ];

    # Home Manager
    home-manager.users.matetamasi = {
      home.packages = with pkgs; [
        nerd-fonts.monaspace
        google-fonts
        masterpdfeditor4
        bat
        libreoffice-qt
        kdePackages.filelight
        wl-clipboard
        piper
        pavucontrol
        firefox
        keepass
        zoxide
        ungoogled-chromium
        qbittorrent
        wineWow64Packages.stable
        winetricks
        winboat
        crosspipe
        gemini-cli
      ];

      home.sessionVariables = {
        EDITOR = "nvim";
        TERM = "konsole";
        DEFAULT_BROWSER = "zen-beta";
      };
      home.sessionPath = [
        "$HOME/.local/bin"
      ];

      fonts.fontconfig.enable = true;
    };
  };
}
