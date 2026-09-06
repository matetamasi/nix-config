_: {
  flake.modules.raserei."wireguard" = {config, ...}: {
    age.secrets.raserei-wg = {
      file = ../../../../secrets/raserei-wg.age;
      owner = "root";
      group = "root";
    };

    networking.wireguard.interfaces.wg0 = {
      ips = ["10.0.0.1/30"];
      listenPort = 51820;
      privateKeyFile = config.age.secrets.raserei-wg.path;
      peers = [
        {
          publicKey = "fjGgz9VttT0ptKA3r85ICeqCHUD2iVn6norKfFTcvEE=";
          allowedIPs = ["10.0.0.2/32"];
        }
      ];
    };
  };
}
