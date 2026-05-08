{...}: {
  flake.modules.nixos."networking" = {
    config,
    lib,
    ...
  }: {
    environment.persistence."/persist".directories = lib.mkIf config.features.impermanence.enable [
      "/etc/NetworkManager/system-connections"
      "/var/lib/zerotier-one"
    ];

    networking.networkmanager = {
      ensureProfiles = {
        environmentFiles = [config.age.secrets.eduroam.path];
        profiles = {
          "eduroam" = {
            connection = {
              id = "eduroam";
              type = "wifi";
            };
            wifi.ssid = "eduroam";
            wifi-security.key-mgmt = "wpa-eap";
            "802-1x" = {
              eap = "ttls;";
              identity = "$EDUROAM_ID";
              anonymous-identity = "anonymous@bme.hu";
              phase2-auth = "pap";
              password = "$EDUROAM_PASSWORD";
              password-flags = 0;
              ca-cert = "${../../resources/ca.pem}";
              altsubject-matches = "DNS:eduroam-radius.net.bme.hu;";
            };
            ipv4.method = "auto";
            ipv6.method = "auto";
          };
        };
      };
    };
  };
}
