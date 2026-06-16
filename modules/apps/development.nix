_: {
  flake.modules.nixos."development" = {
    pkgs,
    inputs,
    config,
    lib,
    ...
  }: {
    environment.persistence."/persist".users.${config.user.name}.directories = lib.mkIf config.features.impermanence.enable [
      "Android"
      ".android"
      ".config/Google"
      ".local/share/Google"
      ".gradle"
      ".local/share/JetBrains"
      ".config/JetBrains"
      ".config/github-copilot"
      ".java/.userPrefs"
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

    users.users.${config.user.name}.extraGroups = ["adbusers" "dialout"];

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
    home-manager.users.${config.user.name} = {
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
