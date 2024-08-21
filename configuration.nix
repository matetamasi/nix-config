{ 
  system ? builtins.currentSystem,
  config,
  pkgs ? import <nixpkgs> {inherit system;},
  pkgs-stable,
  ...
}:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Bootloader
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.efi.canTouchEfiVariables = true;

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

  fileSystems."/".options = ["compress-force=zstd:3" "noatime"];

  # Zsh
  programs.zsh.enable = true;

  # Zram
  zramSwap = {
    enable = true;
    priority = 100;
    algorithm = "zstd";
    memoryPercent = 150;
  };

  # Nvidia
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      offload = {
        enable = true;
	enableOffloadCmd = true;
      };
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

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
      symbolsFile = /home/matetamasi/.local/share/keymaps/xkb/hp;
    };
    layout = "hp,hu";
    variant = "";
  };

  services.zerotierone = {
    enable = true;
    joinNetworks = ["9f77fc393ecc1ecc"];
  };

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
    storageDriver = "btrfs";
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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.matetamasi = {
    isNormalUser = true;
    description = "Tamási Máté";
    extraGroups = [ "networkmanager" "wheel" "docker" "kvm" "libvirt" "dialout" ];
    shell = pkgs.zsh;
    packages = 
    (with pkgs; [
      #THESE REALLY SHOULD NOT BE HERE
      ffmpeg
      xorg.libSM
      libGL

      #THESE SHOULD BE IN HOME INSTEAD
      firefox
      discord
      signal-desktop
      keepass
      maestral
      caprine-bin
      androidStudioPackages.beta
      zoxide
      xclip
      sqlcmd
      gitkraken

      (vscode-with-extensions.override {
         vscode = vscodium;
         vscodeExtensions = with vscode-extensions; [
           vscodevim.vim
         ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
           {
             name = "remote-ssh-edit";
             publisher = "ms-vscode-remote";
             version = "0.47.2";
             sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
           }
         ];
       })
    ])
    ++
    (with pkgs-stable; [
      ungoogled-chromium #TODO use unstable once bugfix is merged
    ]);
  };


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages =
  [
  pkgs.ripgrep
  pkgs.file
  pkgs.gtk3
  pkgs.vim
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
  pkgs.qmk-udev-rules
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
