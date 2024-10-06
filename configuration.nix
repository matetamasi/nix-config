{ 
  config,
  pkgs,
  pkgs-stable,
  lib,
  #nixvim,
  ...
}:

{
  imports =
    [
      ./hardware-configuration.nix
      ./persist.nix
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

  # Zram
  #zramSwap = {
    #enable = true;
    #priority = 100;
    #algorithm = "zstd";
    #memoryPercent = 150;
  #};

  # Nvidia
  #hardware.graphics = {
    #enable = true;
    #enable32Bit = true;
  #};
#
  #services.xserver.videoDrivers = ["nvidia"];
  #hardware.nvidia = {
    #modesetting.enable = true;
    #powerManagement.enable = false;
    #powerManagement.finegrained = false;
    #open = false;
    #nvidiaSettings = true;
    #package = config.boot.kernelPackages.nvidiaPackages.stable;

    #prime = {
      #offload = {
        #enable = true;
	#enableOffloadCmd = true;
      #};
      #intelBusId = "PCI:0:2:0";
      #nvidiaBusId = "PCI:1:0:0";
    #};
  #};

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
      symbolsFile = /home/matetamasi/dot/keymaps/hp;
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

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.defaultSession = "plasma";
  services.desktopManager.plasma6.enable = true;

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

  # Virtualisation
  virtualisation.libvirtd = {
    enable = true;
    qemu.ovmf.enable = true;
  };
  programs.virt-manager.enable = true;

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
    # password: temp a
    root.initialHashedPassword = "$6$FRmKgElD/80xQiXn$aF.tKv0VOLj9D3aUJjoYsj3AzSj1rq5fVooE7tgtNuTawt8ZWgaRyUUxsikX5whbna4jrzXrDZmVFqik.kyc2/";

    matetamasi = {
      # password: temp b
      initialHashedPassword = "$6$iLmo7C9VoAnJZ6v1$qCSORkbiY44IbcrrF1DcTnJtpOkqeD2tGgUoaDgtzPdFqKWKJ28AhJqmuOf8IWoSNu2DQJM.QlWO1Ok05kFgp0";
      isNormalUser = true;
      description = "Tamási Máté";
      extraGroups = [ "networkmanager" "wheel" "docker" "kvm" "libvirt" "dialout" ];
      shell = pkgs.zsh;
    };
  };



  environment.systemPackages =
  [
  pkgs.ripgrep
  pkgs.file
  pkgs.gtk3
  pkgs.vim
  pkgs.alejandra
  pkgs.nix-output-monitor
  pkgs.git
  pkgs.jetbrains.idea-community-bin
  pkgs.tree
  pkgs.warp-terminal
  pkgs.coreutils-full
  pkgs.pciutils
  pkgs.lshw
  pkgs.kotlin
  pkgs.grub2
  pkgs.efibootmgr
  pkgs.glxinfo
  (pkgs.python3.withPackages (python-pkgs: with python-pkgs; [
    numpy
    matplotlib
  ]))
  pkgs.glfw
  pkgs.neofetch
  pkgs.steam-run
  pkgs.gsettings-desktop-schemas
  pkgs.glib
  pkgs.alsa-utils
  pkgs.zsh
  pkgs.htop-vim
  pkgs.libsecret
  pkgs.xorg.xhost
  pkgs.qmk-udev-rules

  # For herbstluftwm - TODO: move to separate file, import conditionally
  # TODO: with pkgs;
  pkgs.pamixer
  pkgs.arandr
  pkgs.xorg.xbacklight
  pkgs.playerctl
  pkgs.scrot
  pkgs.blueman
  pkgs.networkmanagerapplet
  pkgs.xorg.xinit
  pkgs.rofi
  pkgs.polybarFull
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  nix.settings.experimental-features = ["nix-command" "flakes"];
}
