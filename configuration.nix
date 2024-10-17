{ 
  pkgs,
  pkgs-stable,
  ...
}:

{
  imports =
    [
      ./hardware-configuration.nix
      ./persist.nix
      ./configuration
    ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Bootloader
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Systemd
  systemd.enableEmergencyMode = false;

  networking.hostName = "nixos";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  networking.networkmanager.enable = true;

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

  #fileSystems."/".options = ["compress-force=zstd:3" "noatime"];

  # Zsh
  programs.zsh.enable = true;

  services.teamviewer.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    extraLayouts.hp = {
      description = "Hungarian programmer's (US with hu characters on alt)";
      languages = ["hu" "en"];
      symbolsFile = ./keymaps/hp;
    };
    layout = "hp,hu";
    variant = "";
  };

  #services.zerotierone = {
    #enable = true;
    #joinNetworks = ["9f77fc393ecc1ecc"];
    #package = pkgs-stable.zerotierone;
  #};

  services.libinput = {
    enable = true;
    mouse.accelProfile = "flat";
    mouse.accelSpeed = "0";
    touchpad.naturalScrolling = true;
  };

  # Nix-ld
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    swt
  ];

  programs.weylus = {
    enable = true;
    openFirewall = true;
    users = ["matetamasi"];
  }; 

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # QMK
  hardware.keyboard.qmk.enable = true;

  # Docker
  virtualisation.docker = {
    enable = true;
    extraPackages = with pkgs;
    [
      alsa-utils
      alsa-lib
      gtk2
      gtk3
      gtk4
      qemu
      qemu_kvm
      virt-manager
      libvirt
      dnsmasq
      flex
      bison
      edk2
      xorg.xhost
    ];
  };

  # java
  programs.java = {
    enable = true;
    package = pkgs.jdk17;
  };

  users.mutableUsers = false;
  users.users = {
    root.hashedPasswordFile = "/persist/passwords/root.pass";

    matetamasi = {
      hashedPasswordFile = "/persist/passwords/matetamasi.pass";
      isNormalUser = true;
      description = "Tamási Máté";
      extraGroups = [ "networkmanager" "wheel" "docker" "kvm" "libvirt" "dialout" ];
      shell = pkgs.zsh;
    };
  };

  environment.systemPackages = with pkgs;
  [
  ripgrep
  file
  vim
  alejandra
  nix-output-monitor
  git
  jetbrains.idea-community-bin
  tree
  coreutils-full
  pciutils
  lshw
  kotlin
  glxinfo
  (python3.withPackages (python-pkgs: with python-pkgs; [
    numpy
    matplotlib
  ]))
  neofetch
  steam-run
  glib
  alsa-utils
  zsh
  htop-vim
  libsecret
  qmk-udev-rules

  # For herbstluftwm - TODO: move to separate file, import conditionally
  # TODO: with pkgs;
  pamixer
  arandr
  xorg.xbacklight
  playerctl
  scrot
  blueman
  networkmanagerapplet
  xorg.xinit
  rofi
  polybarFull
  ];

  system.stateVersion = "23.11";

  nix.settings.experimental-features = ["nix-command" "flakes"];
}
