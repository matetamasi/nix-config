{...}: {
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
          "DP-1,DP-2,DP-3,HDMI-A-1,HDMI-A-2,eDP-1"
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
      capSysNice = true;
      args = [
        "--rt"
        "--steam"
      ];
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
        prismlauncher #Minecraft launcher
        (makeDesktopItem {
          name = "steam-gamescope";
          desktopName = "Steam (Gamescope TV Mode)";
          icon = "steam";
          exec = "gamescope --prefer-output DP-1,DP-2,DP-3,HDMI-A-1,HDMI-A-2,eDP-1 -f -- steam -gamepadui";
          categories = ["Game"];
        })
      ];
    };
  };
}
