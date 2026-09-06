_: {
  flake.modules.raserei."ssh" = {config, ...}: {
    services.openssh = {
      enable = true;
      listenAddresses = [
        {
          addr = "10.0.0.1";
          port = 22460;
        }
      ];
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
        AllowUsers = ["matetamasi"];
        PerSourcePenalties = "authfail:3600s";
      };
    };
  };
}
