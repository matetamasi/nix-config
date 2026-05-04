{
  pkgs,
  pkgs-stable,
  nixvim,
  zen-browser-pkg,
  config,
  ...
}: {
  imports = [
    nixvim.homeModules.nixvim
    ./home
    #./home/herbstluftwm.nix
  ];
  home.username = "matetamasi";
  home.homeDirectory = "/home/${config.home.username}";

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.gpg = {
    enable = true;
    homedir = "${config.home.homeDirectory}/.gpg/";
  };

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

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

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

  home.shellAliases = {
    # Git
    gc = "git commit -v";
    gcm = "git commit -m";
    gp = "git push";
    gpf = "git push --force-with-lease";
    gd = "git diff";
    gs = "git status";
    glo = "git log --oneline";
    gcp = "git checkout -p";
    ga = "git add";
    gap = "git add -p";
    gar = "git add `git rev-parse --show-toplevel`";
    garp = "git add -p `git rev-parse --show-toplevel`";
  };

  nixpkgs.config.allowUnfree = true;

  home.packages =
    let
      teams-icons = pkgs.runCommand "teams-custom-icons" { nativeBuildInputs = [ pkgs.librsvg ]; } ''
        mkdir -p $out/share/icons/hicolor/512x512/apps
        rsvg-convert -w 512 -h 512 ${./resources/icons/teams/teams-for-linux-BME.svg} -o $out/share/icons/hicolor/512x512/apps/teams-for-linux-BME.png
        rsvg-convert -w 512 -h 512 ${./resources/icons/teams/teams-for-linux-MOK.svg} -o $out/share/icons/hicolor/512x512/apps/teams-for-linux-MOK.png

        mkdir -p $out/share/icons/hicolor/scalable/apps
        cp ${./resources/icons/teams/teams-for-linux-BME.svg} $out/share/icons/hicolor/scalable/apps/teams-for-linux-BME.svg
        cp ${./resources/icons/teams/teams-for-linux-MOK.svg} $out/share/icons/hicolor/scalable/apps/teams-for-linux-MOK.svg
      '';

      teams-for-linux-profiles =
        pkgs.teams-for-linux.overrideAttrs (oldAttrs: {
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
              mimeTypes = [ "x-scheme-handler/msteams" ];
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
              mimeTypes = [ "x-scheme-handler/msteams" ];
            })
          ];
        })
    ; in with pkgs;
    [
      gcc
      gleam
      elixir
      nerd-fonts.monaspace
      google-fonts
      masterpdfeditor4
      bat
      maven
      libreoffice-qt
      ncspot
      spotify
      gimp
      kdePackages.kcolorchooser
      haruna
      zathura
      kdePackages.filelight
      typst
      wl-clipboard
      steam
      protontricks
      steamtinkerlaunch
      protonup-qt
      sc-controller
      r2modman # mod manager for ror2 and others
      prismlauncher #Minecraft launcher
      piper
      pavucontrol
      qmk
      qmk_hid
      firefox
      vesktop
      element-desktop
      krita
      meld
      signal-desktop
      slack
      teams-for-linux-profiles
      teams-icons
      keepass
      caprine-bin
      androidStudioPackages.stable
      zoxide
      gitkraken
      ungoogled-chromium
      qbittorrent
      wineWow64Packages.stable
      winetricks
      winboat
      crosspipe
      gemini-cli
    ]
    ++ [
      zen-browser-pkg
    ];

  fonts.fontconfig.enable = true;

  #dotfiles
  home.file = {
    # Example: ".config/someFile".source = ./path/to/someFile;

    # Example 2:
    # ".config/someOtherFile".text = ''
    #   contents
    # '';

    ".config/zathura/zathurarc".text = ''
      map <C-i> recolor
    '';
  };

  # Environment variables
  home.sessionVariables = {
    EDITOR = "nvim";
    TERM = "konsole";
    DEFAULT_BROWSER = "zen-beta";
  };
  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  home.stateVersion = "23.11";
}
