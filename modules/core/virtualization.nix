_: {
  flake.modules.nixos."virtualization" = {
    pkgs,
    config,
    lib,
    ...
  }: {
    environment.persistence = lib.mkIf config.features.impermanence.enable {
      "/persist".directories = [
        "/var/lib/docker"
      ];
      "/persist/backup".directories = [
        "/var/lib/libvirt"
      ];
      "/persist".users.${config.user.name}.files = [
        ".config/dconf/user" # virt-manager
      ];
    };

    # NixOS
    programs.dconf.enable = true;

    users.users.${config.user.name}.extraGroups = ["libvirtd" "libvirt" "docker" "kvm"];

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
  };
}
