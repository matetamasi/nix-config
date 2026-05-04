{
  pkgs,
  ...
}: {
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
  home-manager.users.matetamasi = {config, ...}: {
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
}
