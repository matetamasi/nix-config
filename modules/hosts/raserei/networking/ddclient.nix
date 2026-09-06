_: {
  flake.modules.raserei."ddclient" = _: {
    services.ddclient = {
      enable = true;
      interval = "1min";
      protocol = "dyndns2";
      server = "update.dedyn.io";
      username = "tamasi.dev";
      passwordFile = "/home/matetamasi/tamasidev_token";
      domains = ["tamasi.dev"];
      usev4 = "webv4, webv4=checkip.dedyn.io";
    };
  };
}
