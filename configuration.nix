#. Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ system ? builtins.currentSystem, config, pkgs ? import <nixpkgs> {inherit system;}, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
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

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Budapest";

  # Select internationalisation properties.
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

  # File system
  fileSystems."/".options = ["compress-force=zstd:3" "noatime"];

  # ZSH
  programs.zsh.enable = true;

  # Zram
  zramSwap = {
    enable = true;
    priority = 100;
    algorithm = "zstd";
    memoryPercent = 150;
  };

  # Nvidia
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
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
    layout = "hp";
    variant = "";
  };

  # Nix-ld
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    swt
  ];

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.defaultSession = "plasma";
  services.desktopManager.plasma6.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # java
  programs.java = {
    enable = true;
	package = pkgs.jdk17;
  };

  # gsettings dconf (for eclipse)
  programs.dconf.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.matetamasi = {
    isNormalUser = true;
    description = "Tamási Máté";
    extraGroups = [ "networkmanager" "wheel" "docker" "kvm" "libvirt" ];
    shell = pkgs.zsh;
    packages = with pkgs;
    [
      firefox
      ungoogled-chromium
      discord
      signal-desktop
      keepass
      maestral
      caprine-bin
      androidStudioPackages.beta
      zoxide
      graphviz
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
    ];
  };


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages =
 # let #TODO: put eclipse back in config
 #   eclipse_dsl_4_30 = import (builtins.fetchGit {
 #     name = "eclipse-dsl-4_30-stable-version";
 #     url = "https://github.com/NixOS/nixpkgs/";
 #     ref = "refs/heads/nixpkgs-unstable";
 #     rev = "e89cf1c932006531f454de7d652163a9a5c86668";
 #   }) { inherit system; };
 #   #nixpkgs.overlays = [ (final: prev: {
 #     #jdk = prev.jdk.override { package = eclipse_dsl_4_30.jdk17; };
 #   #}) ];
 # in
  [
  pkgs.file
  pkgs.gtk3
  pkgs.neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
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
  #nixgl.auto.nixGLDefault
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
  #eclipse_dsl_4_30.eclipses.eclipse-dsl
  #eclipse_dsl_4_30.jdk17
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  nix.settings.experimental-features = ["nix-command" "flakes"];
}
