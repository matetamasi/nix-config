_: {
  flake.modules.nixos."zfs" = {pkgs, ...}: {
    # ZFS
    networking.hostId = "9aa64d3a";
    boot = {
      kernelPackages = pkgs.linuxPackages_6_18;
      kernelParams = [
        "nohibernate"
        "zfs.zfs_arc_max=17179869184"
        "amdgpu.dcdebugmask=0x410"
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

    # Zram
    zramSwap = {
      enable = true;
      priority = 100;
      algorithm = "zstd";
      memoryPercent = 150;
    };
  };
}
