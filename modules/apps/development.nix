{...}: {
  flake.modules.nixos."development" = {
    pkgs,
    inputs,
    config,
    lib,
    ...
  }: {
    environment.persistence."/persist".users.matetamasi.directories = lib.mkIf config.features.impermanence.enable [
      "Android"
      ".android"
      ".config/Google"
      ".local/share/Google"
      ".gradle"
      ".local/share/JetBrains"
      ".config/JetBrains"
      ".local/share/direnv/allow"
      ".eclipse"
      ".gitkraken"
      ".config/GitKraken"
    ];

    # NixOS
    programs.java = {
      enable = true;
      package = pkgs.jdk17;
    };

    environment.systemPackages = with pkgs; [
      jetbrains.idea
      kotlin
      (python3.withPackages (python-pkgs:
        with python-pkgs; [
          numpy
          matplotlib
        ]))
    ];

    # Home Manager
    home-manager.users.matetamasi = {
      config,
      pkgs,
      ...
    }: {
      programs.gpg = {
        enable = true;
        homedir = "${config.home.homeDirectory}/.gpg/";
      };

      home.packages = with pkgs; [
        gcc
        gleam
        elixir
        maven
        androidStudioPackages.stable
        typst
        gitkraken
        meld
        qmk
        qmk_hid
      ];
    };
  };
}
