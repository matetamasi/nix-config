_: {
  flake.modules.common."networking" = {
    config,
    lib,
    ...
  }: {
    environment.persistence."/persist".directories = lib.mkIf config.features.impermanence.enable [
      "/etc/NetworkManager/system-connections"
    ];

    networking = {
      networkmanager.enable = true;
      firewall.enable = true;
    };
  };
}
