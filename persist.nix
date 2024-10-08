# https://github.com/nix-community/impermanence#module-usage
{
  lib,
  ...
}:
{
  fileSystems."/persist".neededForBoot = true;
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/lib/systemd/coredump"
      "/var/lib/nixos"
      "/var/lib/fprint"
      "/etc/NetworkManager/system-connections"
    ];
    files = [
      "/etc/machine-id" # for journalctl
    ];
    users.matetamasi = {
      directories = [
        # Folders I usually work in
        "Downloads"
        "BME"
        "MedveMatek"
        "QMK"
        "Prog_misc"
        "dot"

        # KDE Plasma stuff (should start using plasma-manager instead)
        ".local/share/kscreen"
        ".local/share/kwalletd"
        ".local/share/sddm"
        ".local/share/zoxide"

        # Login state for applications
        ".mozilla/firefox"
        ".config/Signal"
        ".config/vesktop"

        # Chromium & PWAs
        ".config/chromium"


        # Other
        ".ssh"
      ];
      files = [
        ".bash_history"
        ".config/systemsettingsrc"
        ".zsh_history"
      ];
    };
  };


  # Reset root subvolume on boot
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    mkdir /btrfs_tmp
    mount /dev/root_vg/root /btrfs_tmp
    if [[ -e /btrfs_tmp/root ]]; then
        mkdir -p /btrfs_tmp/old_roots
        timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
        mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
    fi

    delete_subvolume_recursively() {
        IFS=$'\n'
        for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
            delete_subvolume_recursively "/btrfs_tmp/$i"
        done
        btrfs subvolume delete "$1"
    }

    for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +90); do
        delete_subvolume_recursively "$i"
    done

    btrfs subvolume create /btrfs_tmp/root
    umount /btrfs_tmp
  '';
}
