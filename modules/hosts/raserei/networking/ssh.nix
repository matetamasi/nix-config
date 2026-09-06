_: {
  flake.modules.raserei."ssh" = {config, ...}: {
    services.openssh = {
      enable = true;
      # openFirewall = true; # TODO: delete
      listenAddresses = [
        {
          addr = "10.0.0.1";
          port = 22460;
        }
      ];
      # ports = [22460]; # TODO: delete
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
