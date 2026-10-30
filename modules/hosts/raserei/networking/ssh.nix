_: {
  flake.modules.raserei."ssh" = {config, ...}: {
    networking.firewall.interfaces.wg0.allowedTCPPorts = [22460];
    services.openssh = {
      enable = true;
      openFirewall = false;
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
