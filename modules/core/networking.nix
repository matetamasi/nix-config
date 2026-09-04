_: {
  flake.modules.common."networking" = {
    config,
    lib,
    ...
  }: {
    environment.persistence = lib.mkIf config.features.impermanence.enable {
      "/persist".directories = [
        "/etc/NetworkManager/system-connections"
      ];
    };

    networking = {
      networkmanager.enable = true;
      firewall.enable = true;
    };
  };
}
