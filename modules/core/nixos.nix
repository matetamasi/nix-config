{
  config,
  pkgs,
  ...
}: {
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Bootloader
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.systemd.enable = true;

  # Systemd
  systemd.enableEmergencyMode = false;

  # Networking
  networking.hostName = "nixos";

  networking.networkmanager.enable = true;

  networking.firewall = {
    enable = true;
    allowedUDPPorts = [25565];
    allowedTCPPorts = [25565];
  };

  time.timeZone = "Europe/Budapest";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Services
  services.printing.enable = true;
  services.teamviewer.enable = true;
  services.zerotierone = {
    enable = true;
    joinNetworks = ["9f77fc393ecc1ecc"];
  };
  services.openssh.enable = true;

  # Sound
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Hardware bits
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.steam-hardware.enable = true;
  hardware.keyboard.qmk.enable = true;

  # X11 / Keymap
  services.xserver.enable = true;
  services.xserver.xkb = {
    extraLayouts.hp = {
      description = "Hungarian programmer's (US with hu characters on alt)";
      languages = ["hu" "en"];
      symbolsFile = ../../keymaps/hp;
    };
    layout = "hp,hu";
    variant = "";
  };

  services.libinput = {
    enable = true;
    mouse.accelProfile = "flat";
    mouse.accelSpeed = "0";
    touchpad.naturalScrolling = true;
  };

  # Misc
  programs.nix-ld.enable = true;
  programs.gamemode.enable = true;

  system.stateVersion = "23.11";

  nix.settings.experimental-features = ["nix-command" "flakes"];
}
