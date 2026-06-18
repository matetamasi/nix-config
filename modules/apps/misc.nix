_: {
  flake.modules.nixos."misc" = {
    pkgs,
    inputs,
    config,
    lib,
    ...
  }: {
    environment.persistence."/persist".users.${config.user.name}.directories = lib.mkIf config.features.impermanence.enable [
      ".mozilla/firefox"
      ".config/chromium"
      ".gemini"
    ];

    # NixOS
    services.udev.packages = [pkgs.headsetcontrol];

    environment.systemPackages = with pkgs; [
      zfs-prune-snapshots
      ripgrep
      file
      vim
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
      inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
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
          bat
          libreoffice-qt
          kdePackages.filelight
          wl-clipboard
          piper
          pavucontrol
          firefox
          keepass
          zoxide
          (hunspell.withDicts (ds: [ds.en_US-large]))
          ungoogled-chromium
          qbittorrent
          wineWow64Packages.stable
          winetricks
          winboat
          crosspipe
          gemini-cli
        ];

        sessionVariables = {
          EDITOR = "nvim";
          TERM = "ghostty";
          DEFAULT_BROWSER = "zen-beta";
        };
        sessionPath = [
          "$HOME/.local/bin"
        ];
      };

      fonts.fontconfig.enable = true;

      xdg.configFile."htop/htoprc".source = ../../resources/htop/htoprc;
    };
  };
}
