{
  pkgs,
  pkgs-stable,
  nixvim,
  ...
}: {
  imports = [
    nixvim.homeManagerModules.nixvim
    ./home
    #./home/herbstluftwm.nix
  ];
  home.username = "matetamasi";
  home.homeDirectory = "/home/matetamasi";

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.gpg = {
    enable = true;
    homedir = "/home/matetamasi/.gpg/";
  };

  programs.git = {
    enable = true;
    userEmail = "matetamasi@protonmail.com";
    userName = "Tamási Máté";
    delta = {
      enable = true;
      options = {
        features = "navigation side-by-side";
      };
    };
  };

  # Default applications
  xdg.mimeApps = {
    enable = true;
    
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
    };
  };

  home.shellAliases = {
    # Nix config management
    nfu = "nix flake update /home/matetamasi/dot/";
    nomb = "nom build /home/matetamasi/dot#nixosConfigurations.nixos.config.system.build.toplevel -o /home/matetamasi/dot/result";
    # Git
    gc  = "git commit -v";
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

  home.packages = with pkgs; [
    gleam
    elixir
    uppaal
    godot_4
    gprolog
    nerd-fonts.monaspace
    google-fonts
    # poppins
    masterpdfeditor4
    bat
    maven
    libreoffice-qt
    ncspot
    spotify
    gimp
    kcolorchooser
    haruna
    zathura
    filelight
    typst
    wl-clipboard
    xclip
    steam
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
    signal-desktop
    slack
    keepass
    maestral
    caprine-bin
    androidStudioPackages.beta
    zoxide
    gitkraken
    ungoogled-chromium
    qbittorrent
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
    TERM = "wezterm";
    DEFAULT_BROWSER = "firefox";
  };
  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  home.stateVersion = "23.11";
}
