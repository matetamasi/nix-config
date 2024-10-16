{
  # Enable sddm with wayland support
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  # Make plasma the default desktop environment
  services.displayManager.defaultSession = "plasma";

  # Fix bug where password login makes sddm have a 30s timeout
  # See: https://github.com/NixOS/nixpkgs/issues/239770
  security.pam.services.login.fprintAuth = false;
}
