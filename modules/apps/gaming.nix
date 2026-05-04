{
  pkgs,
  ...
}: {
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
}
