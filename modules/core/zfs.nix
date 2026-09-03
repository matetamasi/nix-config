_: {
  flake.modules.common."zfs" = {pkgs, ...}: {
    # ZFS
    boot = {
      kernelPackages = pkgs.linuxPackages_6_18;
      kernelParams = [
        "nohibernate"
        "zfs.zfs_arc_max=17179869184"
      ];
      supportedFilesystems = ["vfat" "zfs"];
      zfs = {
        devNodes = "/dev/disk/by-id/";
        forceImportRoot = false;
        requestEncryptionCredentials = true;
        package = pkgs.zfs_unstable;
      };
    };
    services.zfs = {
      autoScrub.enable = true;
      trim.enable = true;
    };

    environment.systemPackages = with pkgs; [
      zfs-prune-snapshots
    ];

    # Zram
    zramSwap = {
      enable = true;
      priority = 100;
      algorithm = "zstd";
      memoryPercent = 150;
    };
  };
}
