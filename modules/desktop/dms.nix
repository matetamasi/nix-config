{inputs, ...}: {
  flake.modules.nixos."dms" = {
    config,
    lib,
    pkgs,
    ...
  }: {
    imports = [
      inputs.dms.nixosModules.dank-material-shell
      inputs.dank-greeter.nixosModules.default
    ];

    environment = {
      persistence."/persist/backup".users.${config.user.name} = {
        directories = lib.mkIf config.features.impermanence.enable [
          ".config/DankMaterialShell"
          ".local/state/DankMaterialShell"
        ];
        files = lib.mkIf config.features.impermanence.enable [
          ".config/mango/dms/colors.conf"
          ".config/ghostty/themes/dankcolors"
        ];
      };

      systemPackages = with pkgs; [
        ddcutil
      ];
    };

    # NixOS
    hardware.i2c.enable = true;
    users.users.${config.user.name}.extraGroups = ["i2c"];

    programs.dms-greeter = {
      enable = true;
      compositor.name = "mango";
      configHome = "/home/${config.user.name}";
    };
    programs.dank-material-shell = {
      enable = true;
      enableSystemMonitoring = true;
      enableDynamicTheming = true;
      enableAudioWavelength = true;
      enableCalendarEvents = true;
      enableClipboardPaste = true;
    };

    # Home Manager
    home-manager.users.${config.user.name} = {
      imports = [
        inputs.dms.homeModules.dank-material-shell
      ];

      home.file.".config/mango/scripts".source = ../../resources/mango/scripts;

      programs.ghostty.settings.theme = "dankcolors";
    };
  };
}
