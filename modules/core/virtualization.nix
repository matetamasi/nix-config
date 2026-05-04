{
  pkgs,
  ...
}: {
  # NixOS
  programs.dconf.enable = true;

  users.users.matetamasi.extraGroups = ["libvirtd" "docker" "kvm"];

  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    virtio-win
    win-spice
    adwaita-icon-theme
  ];

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
      };
    };
    spiceUSBRedirection.enable = true;

    docker = {
      enable = true;
      extraPackages = with pkgs; [
        alsa-utils
        alsa-lib
        gtk2
        gtk3
        gtk4
        qemu
        qemu_kvm
        virt-manager
        libvirt
        dnsmasq
        flex
        bison
        edk2
        xhost
        android-tools
      ];
    };
  };

  services.spice-vdagentd.enable = true;
}
