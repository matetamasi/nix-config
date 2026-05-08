{...}: {
  flake.modules.nixos."hyprland" = {...}: {
    # NixOS
    programs.hyprland.enable = true;
  };
}
