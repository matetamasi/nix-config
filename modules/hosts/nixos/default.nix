{inputs, ...}: {
  flake.nixosConfigurations.nixos = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules =
      (with inputs; [
        nixos-hardware.nixosModules.framework-16-7040-amd
        agenix.nixosModules.default
        disko.nixosModules.default
        home-manager.nixosModules.home-manager
        impermanence.nixosModules.impermanence
        angrr.nixosModules.angrr
      ])
      ++ (with inputs.self.modules.nixos; [
        disko
        hardware-configuration
      ])
      ++ (with inputs.self.modules.common; [
        cli
        browser
        development
        gaming
        gc
        git
        home-manager
        impermanence
        misc
        multimedia
        networking
        core
        nixvim
        plasma
        secrets
        starship
        teams
        users
        virtualization
        zfs
        zsh
        mango
        dms
        terminal
      ])
      ++ [
        ({
          config,
          lib,
          ...
        }: {
          _module.args = {inherit inputs;};
          networking = {
            hostName = "nixos";
            hostId = "9aa64d3a";
            firewall = {
              allowedUDPPorts = [25565];
              allowedTCPPorts = [25565];
            };

            networkmanager.ensureProfiles = {
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
                    ca-cert = "${../../../resources/ca.pem}";
                    altsubject-matches = "DNS:eduroam-radius.net.bme.hu;";
                  };
                  ipv4.method = "auto";
                  ipv6.method = "auto";
                };
              };
            };
          };

          users.users = {
            root.hashedPasswordFile = "/persist/passwords/root.pass";
            ${config.user.name}. hashedPasswordFile = "/persist/passwords/${config.user.name}.pass";
          };

          # Bootloader
          boot = {
            initrd.systemd.enable = true;
            loader = {
              systemd-boot.enable = false;
              grub = {
                enable = true;
                device = "nodev";
                efiSupport = true;
                useOSProber = true;
              };
              efi.canTouchEfiVariables = true;
            };
          };

          # Systemd
          systemd.enableEmergencyMode = false;
          features.impermanence.enable = true;

          environment.persistence."/persist".directories = lib.mkIf config.features.impermanence.enable [
            "/var/lib/zerotier-one"
          ];

          # Services
          services = {
            printing.enable = true;
            teamviewer.enable = true;
            zerotierone = {
              enable = true;
              joinNetworks = ["9f77fc393ecc1ecc"];
            };
            openssh.enable = true;

            # Sound
            pulseaudio.enable = false;
            pipewire = {
              enable = true;
              alsa.enable = true;
              alsa.support32Bit = true;
              pulse.enable = true;
            };
            # X11 / Keymap
            xserver.enable = true;
            xserver.xkb = {
              extraLayouts.hp = {
                description = "Hungarian programmer's (US with hu characters on alt)";
                languages = ["hu" "en"];
                symbolsFile = ../../../keymaps/hp;
              };
              layout = "hp,hu";
              variant = "";
            };

            libinput = {
              enable = true;
              mouse.accelProfile = "flat";
              mouse.accelSpeed = "0";
              touchpad.naturalScrolling = true;
            };
          };

          security.rtkit.enable = true;

          hardware = {
            bluetooth = {
              enable = true;
              powerOnBoot = true;
            };
            keyboard.qmk.enable = true;
          };

          # Misc
          programs.nix-ld.enable = true;

          system.stateVersion = "23.11";
          home-manager.users.${config.user.name}.home.stateVersion = "23.11";
        })
      ];
  };
}
