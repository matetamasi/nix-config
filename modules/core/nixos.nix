_: {
  flake.modules.nixos."nixos" = {
    config,
    pkgs,
    ...
  }: {
    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # Bootloader
    boot = {
      initrd.systemd.enable = true;
      loader = {
        systemd-boot.enable = false;
        grub = {
          enable = true;
          device = "nodev";
          efiSupport = true;
          useOSProber = true;
        };
        efi.canTouchEfiVariables = true;
      };
    };

    # Systemd
    systemd.enableEmergencyMode = false;

    # Networking
    networking = {
      hostName = "nixos";

      networkmanager.enable = true;

      firewall = {
        enable = true;
        allowedUDPPorts = [25565];
        allowedTCPPorts = [25565];
      };
    };

    time.timeZone = "Europe/Budapest";

    i18n = {
      defaultLocale = "en_US.UTF-8";

      extraLocaleSettings = {
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
    };

    # Services
    services = {
      printing.enable = true;
      teamviewer.enable = true;
      zerotierone = {
        enable = true;
        joinNetworks = ["9f77fc393ecc1ecc"];
      };
      openssh.enable = true;

      # Sound
      pulseaudio.enable = false;
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };
      # X11 / Keymap
      xserver.enable = true;
      xserver.xkb = {
        extraLayouts.hp = {
          description = "Hungarian programmer's (US with hu characters on alt)";
          languages = ["hu" "en"];
          symbolsFile = ../../keymaps/hp;
        };
        layout = "hp,hu";
        variant = "";
      };

      libinput = {
        enable = true;
        mouse.accelProfile = "flat";
        mouse.accelSpeed = "0";
        touchpad.naturalScrolling = true;
      };
    };

    security.rtkit.enable = true;

    hardware = {
      bluetooth = {
        enable = true;
        powerOnBoot = true;
      };
      keyboard.qmk.enable = true;
    };

    # Misc
    programs.nix-ld.enable = true;

    system.stateVersion = "23.11";

    nix.settings.experimental-features = ["nix-command" "flakes"];
  };
}
