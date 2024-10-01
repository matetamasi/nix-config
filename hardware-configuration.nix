# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.initrd.availableKernelModules = ["ahci" "xhci_pci" "virtio_pci" "sr_mod" "virtio_blk"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = ["defaults" "size=25%" "mode=755"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/7800-A81B";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/7f48ece7-936e-44bf-aebf-a776e69a2327";
    fsType = "btrfs";
    options = ["subvol=persist"];
    neededForBoot = true;
  };

  boot.initrd.luks.devices."crypted".device = "/dev/disk/by-uuid/b9bcad6b-65d5-4e4c-968f-25bcbe803627";

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/7f48ece7-936e-44bf-aebf-a776e69a2327";
    fsType = "btrfs";
    options = ["subvol=nix"];
  };

  fileSystems."/var/log" = {
    device = "/dev/disk/by-uuid/7f48ece7-936e-44bf-aebf-a776e69a2327";
    fsType = "btrfs";
    options = ["subvol=log"];
  };

  fileSystems."/etc/nixos" = {
    device = "/var/log/persist/etc/nixos";
    fsType = "none";
    options = ["bind"];
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/1ee64230-3a75-4f76-8497-894e2bef6572";}
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp1s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
