{ config, pkgs, pkgs-stable, nixvim, ... }:

{
  imports = [
    nixvim.homeManagerModules.nixvim
    ./home
    #./home/herbstluftwm.nix
  ];
  home.username = "matetamasi";
  home.homeDirectory = "/home/matetamasi";

  programs = {

    home-manager.enable = true;

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    monaspace
    poppins
    masterpdfeditor4
    dotnet-sdk_8
    postman
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
    discord
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
  };

  home.stateVersion = "23.11";
}
