_: {
  flake.modules.nixos."wireguard" = {config, ...}: {
    age.secrets.frammenwerken-wg = {
      file = ../../../../secrets/frammenwerken-wg.age;
      owner = "root";
      group = "root";
    };

    networking.wireguard.interfaces.wg0 = {
      ips = ["10.0.0.2/30"];
      privateKeyFile = config.age.secrets.frammenwerken-wg.path;

      peers = [
        {
          publicKey = "qEytTggA9sctkuKkoPEd1W5LDsae2rKnPNmiR7wZOiI=";
          allowedIPs = ["10.0.0.1/32"];
          endpoint = "tamasi.dev:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
