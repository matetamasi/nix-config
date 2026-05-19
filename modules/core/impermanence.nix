{...}: {
  flake.modules.nixos."impermanence" =
    # https://github.com/nix-community/impermanence#module-usage
    {
      config,
      lib,
      pkgs,
      ...
    }: {
      options.features.impermanence.enable = lib.mkEnableOption "system-wide impermanence";

      config = lib.mkIf config.features.impermanence.enable {
        fileSystems."/persist".neededForBoot = true;
        fileSystems."/persist/backup".neededForBoot = true;
        environment.persistence."/persist" = {
          hideMounts = true;
          directories = [
            "/var/lib/systemd/coredump"
            "/var/lib/nixos"
            "/var/lib/fprint"
            "/var/lib/bluetooth"
          ];
          files = [
            "/etc/machine-id" # for journalctl
            "/etc/ssh/ssh_host_ed25519_key"
            "/etc/ssh/ssh_host_ed25519_key.pub"
            "/etc/ssh/ssh_host_rsa_key"
            "/etc/ssh/ssh_host_rsa_key.pub"
          ];
          users.${config.user.name} = {
            directories = [
              # Folders I usually work in
              "Downloads"
              "Downloads/Torrent"
              "Proton_drive"

              # Cache
              ".cache"

              # Wine
              ".wine"

              ".local/share/zoxide"

              # Login state for applications
              ".config/rclone"
              ".config/uppaal"

              # Desktop entries & icons
              ".local/share/applications"
              ".local/share/icons"

              # Godot
              ".config/godot"
              ".local/share/godot"

              # Other
              ".ssh" # SSH
              ".gpg"
            ];
            files = [
              ".local/state/cosmic-comp/outputs.ron" # Cosmic display configuration
            ];
          };
        };

        environment.persistence."/persist/backup" = {
          hideMounts = true;
          directories = [
          ];
          users.${config.user.name} = {
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
      };
    };
}
