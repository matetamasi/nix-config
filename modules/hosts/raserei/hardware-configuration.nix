_: {
  flake.modules.raserei."hardware-configuration" = {
    lib,
    modulesPath,
    ...
  }: {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

    boot = {
      initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod"];
      initrd.kernelModules = [];
      kernelModules = ["kvm-intel"];
      extraModulePackages = [];
    };

    networking.useDHCP = lib.mkDefault true;
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  };
}
