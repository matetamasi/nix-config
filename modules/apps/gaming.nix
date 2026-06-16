_: {
  flake.modules.nixos."gaming" = {
    pkgs,
    config,
    lib,
    ...
  }: {
    environment.persistence = lib.mkIf config.features.impermanence.enable {
      "/persist".users.${config.user.name}.directories = [
        ".local/share/Steam"
        ".config/r2modman"
        ".config/r2modmanPlus-local"
      ];
      "/persist/backup".users.${config.user.name}.directories = [
        ".local/share/PrismLauncher"
        ".config/steamtinkerlaunch"
        ".klei"
        ".local/share/UnrailedGame"
      ];
    };

    programs.steam = {
      enable = true;
      extest.enable = true;
      extraCompatPackages = [pkgs.steamtinkerlaunch];
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      gamescopeSession = {
        enable = true;
        args = [
          "--prefer-output"
          "DP-1,DP-2,DP-3,DP-4,DP-5,DP-6,DP-7,DP-8,DP-9,DP-10,DP-11,DP-12,DP-13,DP-14,DP-15,HDMI-A-1,HDMI-A-2,eDP-1,eDP-2"
        ];
      };
      protontricks.enable = true;

      package = pkgs.steam.override {
        extraPkgs = pkgs:
          with pkgs; [
            hidapi
            libgourou
          ];
      };
    };

    programs.gamescope = {
      enable = true;
      capSysNice = false;
    };

    hardware.steam-hardware.enable = true;

    programs.gamemode = {
      enable = true;
      enableRenice = true;
    };

    users.users.${config.user.name}.extraGroups = ["gamemode"];

    home-manager.users.${config.user.name} = {
      home.packages = with pkgs; [
        protontricks
        protonup-qt
        sc-controller
        r2modman # mod manager for ror2 and others
        prismlauncher # Minecraft launcher
      ];
    };
  };
}
