# https://github.com/nix-community/impermanence#module-usage
{
  lib,
  ...
}:
{
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
    ];
    files = [
      "/etc/machine-id" # for journalctl
    ];
    users.matetamasi = {
      directories = [
        # Folders I usually work in
        "Downloads"
        "Downloads/Torrent"
        "Proton_drive"

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
        ".config/rclone"
        ".config/uppaal"

        # Chromium & PWAs
        ".config/chromium"
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
      ];
      files = [
        ".local/state/cosmic-comp/outputs.ron" # Cosmic display configuration
        ".local/share/desktop-directories/chrome-apps.directory"
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
        "Prog_misc"
        "Gaming"
        "Documents"
        "Pictures"

        # Cosmic desktop
        ".config/cosmic"

        # Prism launcher (minecraft)
        ".local/share/PrismLauncher"

        # Other
        ".local/bin"

      ];

      files = [
        ".bash_history"
        ".zsh_history"
      ];

    };
  };


  # Roll back to blank root on boot
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zpool import zfspool
    zfs rollback -r zfspool/root@blank
  '';
}
