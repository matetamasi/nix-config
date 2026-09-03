{inputs, ...}: {
  flake.nixosConfigurations.raserei = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules =
      (with inputs; [
        agenix.nixosModules.default
        disko.nixosModules.default
        home-manager.nixosModules.home-manager
        impermanence.nixosModules.impermanence
      ])
      ++ (with inputs.self.modules.raserei; [
        hardware-configuration
        disko
      ])
      ++ (with inputs.self.modules.common; [
        cli
        gc
        git
        home-manager
        impermanence
        networking
        core
        nixvim
        secrets
        starship
        users
        zfs
        zsh
      ])
      ++ [
        ({config, ...}: {
          _module.args = {inherit inputs;};
          networking.hostName = "raserei";
          features.impermanence.enable = false;

          system.stateVersion = "26.05";
          home-manager.users.${config.user.name}.home.stateVersion = "26.05";

	  boot.loader.systemd-boot.enable = true;
  	  boot.loader.efi.canTouchEfiVariables = true;

  services = {
  openssh = {
    enable = true;
    openFirewall = true;
    ports = [22460];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = ["matetamasi"];
      PerSourcePenalties = "authfail:3600s";
    };
  };
  ddclient = {
    enable = true;
    interval = "1min";
    protocol = "dyndns2";
    server = "update.dedyn.io";
    username = "tamasi.dev";
    passwordFile = "/home/matetamasi/tamasidev_token"; 
    domains = [ "tamasi.dev" ];
    usev4 = "webv4, webv4=checkip.dedyn.io";
  };
  };
        })
      ];
  };
}
