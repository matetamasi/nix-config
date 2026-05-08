{...}: {
  flake.modules.nixos."gaming" = {
    pkgs,
    config,
    lib,
    ...
  }: {
    environment.persistence = lib.mkIf config.features.impermanence.enable {
      "/persist".users.matetamasi.directories = [
        ".local/share/Steam"
        ".config/r2modman"
        ".config/r2modmanPlus-local"
      ];
      "/persist/backup".users.matetamasi.directories = [
        ".local/share/PrismLauncher"
        ".config/steamtinkerlaunch"
        ".klei"
        ".local/share/UnrailedGame"
      ];
    };

    home-manager.users.matetamasi = {
      home.packages = with pkgs; [
        steam
        protontricks
        steamtinkerlaunch
        protonup-qt
        sc-controller
        r2modman # mod manager for ror2 and others
        prismlauncher #Minecraft launcher
      ];
    };
  };
}
