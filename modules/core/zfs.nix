{
  pkgs,
  ...
}: {
  # ZFS
  networking.hostId = "9aa64d3a";
  boot.kernelPackages = pkgs.linuxPackages_6_18;
  boot.kernelParams = [
    "nohibernate"
    "zfs.zfs_arc_max=17179869184"
    "amdgpu.dcdebugmask=0x410"
  ];
  boot.supportedFilesystems = ["vfat" "zfs"];
  boot.zfs = {
    devNodes = "/dev/disk/by-id/";
    forceImportAll = true;
    requestEncryptionCredentials = true;
    package = pkgs.zfs_unstable;
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
}
