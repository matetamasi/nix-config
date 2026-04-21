# https://github.com/nix-community/impermanence#module-usage
{
  lib,
  pkgs,
  ...
}: {
  fileSystems."/persist".neededForBoot = true;
  fileSystems."/persist/backup".neededForBoot = true;
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/lib/systemd/coredump"
      "/var/lib/nixos"
      "/var/lib/fprint"
      "/etc/NetworkManager/system-connections"
      "/var/lib/bluetooth"
      "/var/lib/zerotier-one"
      "/var/lib/docker"
    ];
    files = [
      "/etc/machine-id" # for journalctl
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"

    ];
    users.matetamasi = {
      directories = [
        # Folders I usually work in
        "Downloads"
        "Downloads/Torrent"
        "Proton_drive"

        # Cache
        ".cache"

        # Wine
        ".wine"

        # KDE Plasma stuff (should start using plasma-manager instead)
        ".local/share/kscreen"
        ".local/share/kwalletd"
        ".local/share/sddm"
        ".local/share/zoxide"

        # Login state for applications
        ".mozilla/firefox"
        ".config/Signal"
        ".config/vesktop"
        ".config/Caprine" # Messenger client
        ".config/rclone"
        ".config/Slack"
        ".config/uppaal"
        ".config/spotify"
        ".config/Element"

        ".zen" # Zen browser

        # Chromium
        ".config/chromium"

        # Desktop entries & icons
        ".local/share/applications"
        ".local/share/icons"

        # Godot
        ".config/godot"
        ".local/share/godot"

        # Steam
        ".local/share/Steam"

        # r2modman
        ".config/r2modman"
        ".config/r2modmanPlus-local"

        # Other
        ".ssh" # SSH
        ".gpg"

        # Android development stuff
        "Android"
        ".android"
        ".config/Google"
        ".local/share/Google"
        ".gitkraken"
        ".config/GitKraken"
        ".gradle"

        # IntelliJ
        ".local/share/JetBrains"
        ".config/JetBrains"

        # Direnv
        ".local/share/direnv/allow"

        # Eclipse
        ".eclipse"
      ];
      files = [
        ".local/state/cosmic-comp/outputs.ron" # Cosmic display configuration
        ".config/dconf/user" # virt-manager
      ];
    };
  };

  environment.persistence."/persist/backup" = {
    hideMounts = true;
    directories = [
      "/var/lib/libvirt"
    ];
    users.matetamasi = {
      directories = [
        # Folders I usually work in
        "dot"
        "BME"
        "MedveMatek"
        "QMK"
        "ZMK"
        "Prog_misc"
        "Gaming"
        "Documents"
        "Pictures"

        # # Winboat
        "winboat"
        ".winboat"

        # Cosmic desktop
        ".config/cosmic"

        # Prism launcher (minecraft)
        ".local/share/PrismLauncher"

        # Steam/proton configuration layer
        ".config/steamtinkerlaunch"

        # Don't Starve Together
        ".klei"

        # Unrailed
        ".local/share/UnrailedGame"

        # Other
        ".local/bin"
      ];

      files = [
        ".bash_history"
        ".config/zsh/.zsh_history"
      ];
    };
  };

  # Roll back to blank root on boot
  boot.initrd.systemd.services.rollback = {
    description = "Rollback ZFS datasets";
    wantedBy = [
      "initrd.target"
    ];
    after = [
      "systemd-cryptsetup@crypted.service"
      "zfs-import-zfspool.service"
    ];
    before = [
      "sysroot.mount"
    ];
    path = with pkgs; [
      zfs
    ];
    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";
    script = ''
      zfs rollback -r zfspool/root@blank
    '';
  };
}
