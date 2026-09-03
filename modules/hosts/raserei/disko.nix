_: {
  flake.modules.raserei."disko" = _: {
    disko.devices = {
      disk = {
        main = {
          device = "/dev/disk/by-id/nvme-eui.01000000000000008ce38e0400091afe";
          type = "disk";
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                size = "1G";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = ["defaults" "umask=0077"];
                };
              };
              root = {
                size = "100%";
                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/";
                };
              };
            };
          };
        };

        data1 = {
          device = "/dev/disk/by-id/wwn-0x5000c500a6633d4b";
          type = "disk";
          content = {
            type = "gpt";
            partitions.zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "tank";
              };
            };
          };
        };

        data2 = {
          device = "/dev/disk/by-id/wwn-0x5000c500955d123f";
          type = "disk";
          content = {
            type = "gpt";
            partitions.zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "tank";
              };
            };
          };
        };

        data3 = {
          device = "/dev/disk/by-id/wwn-0x5000c500955cc68f";
          type = "disk";
          content = {
            type = "gpt";
            partitions.zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "tank";
              };
            };
          };
        };

        data4 = {
          device = "/dev/disk/by-id/wwn-0x5000c500a6eb7ac3";
          type = "disk";
          content = {
            type = "gpt";
            partitions.zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "tank";
              };
            };
          };
        };
      };

      zpool = {
        tank = {
          type = "zpool";
          mode = "raidz1";
          rootFsOptions = {
            compression = "zstd";
            "com.sun:auto-snapshot" = "false";
          };
          mountpoint = "/tank";
          datasets = {
            root = {
              type = "zfs_fs";
              mountpoint = "/tank/data";
            };
            backups = {
              type = "zfs_fs";
              mountpoint = "/tank/backups";
            };
          };
        };
      };
    };
  };
}
