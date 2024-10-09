{
  config,
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
    elixir
    monaspace
    poppins
    masterpdfeditor4
    dotnet-sdk_8
    postman
    bat
    maven
    gsettings-desktop-schemas
    libreoffice-qt
    ncspot
    gimp
    obs-studio
    haruna
    zathura
    filelight
    typst
    wl-clipboard
    spotify
    steam
    sc-controller
    prismlauncher #Minecraft launcher
    protonup-qt
    freerdp
    remmina
    plantuml
    staruml
    piper
    pavucontrol
    qmk
    qmk_hid
    firefox
    vesktop
    signal-desktop
    keepass
    maestral
    caprine-bin
    androidStudioPackages.beta
    zoxide
    xclip
    sqlcmd
    gitkraken
    ungoogled-chromium
    # shell scripts
    #(pkgs.writeShellScriptBin "my-hello" ''
    #  echo "Hello, ${config.home.username}!"
    #'')
  ];

  fonts.fontconfig.enable = true;

  #dotfiles
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
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

  home.stateVersion = "23.11";
}
