{
  ...
}: let
  device = "/dev/nvme1n1";
in {
  disko.devices = {
    disk.main = {
      inherit device;
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          efi = {
            name = "efi";
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [
                "defaults"
                "umask=0077"
              ];
            };
          };
          luks = {
            size = "100%";
            content = {
              type = "luks";
              name = "crypted";
              settings.allowDiscards = true;
              content = {
	        type = "zfs";
                pool = "zfspool";
              };
            };
          };
        };
      };
    };
    zpool = {
      zfspool = {
        type = "zpool";
        rootFsOptions = {
          canmount = "off";
          mountpoint = "none";
          normalization = "formD";
          checksum = "edonr";
          compression = "zstd";
          "com.sun:auto-snapshot" = "false";
        };
        options = {
          ashift = "12";
          autotrim = "on";
        };
        
        datasets = {
          # zfs uses cow free space to delete files when the disk is completely filled
          reserved = {
            options = {
              canmount = "off";
              mountpoint = "none";
              reservation = "20GiB";
            };
            type = "zfs_fs";
          };
          # dataset where files that don't need to be backed-up but should persist between boots are stored
          # the Impermanence module is what ensures files are correctly stored here
          persist = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/persist";
            options."com.sun:auto-snapshot" = "false";
            postCreateHook = "zfs snapshot zfspool/persist@blank";
          };
          # dataset where all files that should both persist and need to be backed up are stored
          # the Impermanence module is what ensures files are correctly stored here
          persistSave = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/persist/backup";
            options."com.sun:auto-snapshot" = "false";
            postCreateHook = "zfs snapshot zfspool/persistSave@blank";
          };
          # Nix store etc. Needs to persist, but doesn't need to be backed up
          nix = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/nix";
            options = {
              atime = "off";
              canmount = "on";
              "com.sun:auto-snapshot" = "false";
            };
            postCreateHook = "zfs snapshot zfspool/nix@blank";
          };
          varlog = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/var/log";
            options = {
              atime = "off";
              canmount = "on";
              "com.sun:auto-snapshot" = "false";
            };
            postCreateHook = "zfs snapshot zfspool/varlog@blank";
          };
          # Where everything else lives, and is wiped on reboot by restoring a blank zfs snapshot.
          root = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            options."com.sun:auto-snapshot" = "false";
            mountpoint = "/";
            postCreateHook = ''
                zfs snapshot zfspool/root@blank
            '';
          };
        };
      };
    };
  };
}
