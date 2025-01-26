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
      "/var/lib/libvirt"
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
        "Pictures"
        "Virtualization"
        "BME"
        "MedveMatek"
        "QMK"
        "Prog_misc"
        "dot"

        # Wine
        ".wine"

        # KDE Plasma stuff (should start using plasma-manager instead)
        ".local/share/kscreen"
        ".local/share/kwalletd"
        ".local/share/sddm"
        ".local/share/zoxide"

        # Cosmic desktop
        ".config/cosmic"

        # Login state for applications
        ".mozilla/firefox"
        ".config/Signal"
        ".config/vesktop"

        # Chromium & PWAs
        ".config/chromium"
        ".local/share/applications"
        ".local/share/icons"

        # Steam
        ".local/share/Steam"

        # r2modman
        ".config/r2modman"
        ".config/r2modmanPlus-local"

        # Other
        ".local/bin"
        ".config/Caprine" # Messenger client
        ".ssh" # SSH
      ];
      files = [
        ".local/state/cosmic-comp/outputs.ron" # Cosmic display configuration
        ".local/share/desktop-directories/chrome-apps.directory"
        ".zsh_history"
        ".bash_history"
        ".config/systemsettingsrc"
      ];
    };
  };


  # Roll back to blank root on boot
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zpool import zfspool
    zfs rollback -r zfspool/root@blank
  '';
}
