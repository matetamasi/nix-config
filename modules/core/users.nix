{...}: {
  flake.modules.nixos."users" = {pkgs, ...}: {
    users.mutableUsers = false;
    users.users = {
      root.hashedPasswordFile = "/persist/passwords/root.pass";

      matetamasi = {
        hashedPasswordFile = "/persist/passwords/matetamasi.pass";
        isNormalUser = true;
        description = "Tamási Máté";
        extraGroups = ["networkmanager" "wheel" "docker" "kvm" "libvirt" "dialout" "adbusers" "gamemode"];
        shell = pkgs.zsh;
      };
    };
  };
}
