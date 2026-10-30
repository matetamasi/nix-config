{inputs, ...}: {
  flake.modules.common."stylix" = {
    config,
    lib,
    pkgs,
    ...
  }: {
    imports = lib.optional (inputs ? stylix) inputs.stylix.nixosModules.stylix;

    stylix = {
      enable = lib.mkDefault true;
      autoEnable = lib.mkDefault true;
      polarity = lib.mkDefault "dark";

      # --- MODE B
      base16Scheme = lib.mkDefault "${pkgs.base16-schemes}/share/themes/monokai.yaml";
      image = lib.mkDefault (pkgs.runCommand "recolored-wallpaper.png" {
          nativeBuildInputs = [pkgs.imagemagick pkgs.lutgen];
        } ''
          magick ${../../resources/wallpapers/wallhaven-1poqe1-3440x1440.jpg} \
            -colorspace HSL -channel G -evaluate multiply 1.5 -channel B -evaluate set 50% +channel -colorspace sRGB \
            boosted_hues.png

          lutgen apply -R -s=128.0 -n=4 boosted_hues.png -o mapped_palette.png -- \
            ${lib.escapeShellArgs config.lib.stylix.colors.withHashtag.toList}

          magick ${../../resources/wallpapers/wallhaven-1poqe1-3440x1440.jpg} mapped_palette.png -compose Colorize -composite $out

          rm -f boosted_hues.png mapped_palette.png
        '');

      fonts = {
        monospace = {
          package = pkgs.nerd-fonts._0xproto;
          name = "0xProto Nerd Font";
        };
        sansSerif = {
          package = pkgs.nerd-fonts._0xproto;
          name = "0xProto Nerd Font";
        };
        serif = {
          package = pkgs.nerd-fonts._0xproto;
          name = "0xProto Nerd Font";
        };
        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };
        sizes = {
          applications = lib.mkDefault 11;
          terminal = lib.mkDefault 11;
          desktop = lib.mkDefault 10;
          popups = lib.mkDefault 10;
        };
      };

      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 24;
      };

      targets = {
        gtk.enable = lib.mkDefault true;
        qt.enable = lib.mkDefault true;
      };
    };

    programs.dank-material-shell.enableDynamicTheming = lib.mkDefault false;

    home-manager.users.${config.user.name} = {lib, ...}: {
      programs.yazi = {
        enable = lib.mkDefault true;
        shellWrapperName = "y";
        enableZshIntegration = true;
        settings = {
          mgr.show_hidden = true;
        };
      };

      home.file.".config/stylix/wallpaper.png".source = config.stylix.image;

      stylix.targets = {
        ghostty.enable = lib.mkDefault true;
        yazi.enable = lib.mkDefault true;
        vesktop.enable = lib.mkDefault true;
        vencord.enable = lib.mkDefault true;
        spotify-player.enable = lib.mkDefault true;
        spicetify.enable = lib.mkDefault true;
        gtk.enable = lib.mkDefault true;
        qt.enable = lib.mkDefault true;
      };

      wayland.windowManager.mango.settings = {
        border_color = lib.mkDefault "0x${config.lib.stylix.colors.base03}ff";
        focus_color = lib.mkDefault "0x${config.lib.stylix.colors.base0D}ff";
        urgent_color = lib.mkDefault "0x${config.lib.stylix.colors.base08}ff";
        root_color = lib.mkDefault "0x${config.lib.stylix.colors.base00}ff";
        drop_color = lib.mkDefault "0x${config.lib.stylix.colors.base0D}55";
        split_color = lib.mkDefault "0x${config.lib.stylix.colors.base08}ff";
        scratchpad_color = lib.mkDefault "0x${config.lib.stylix.colors.base03}ff";
      };

      home.file.".config/dms/themes/Stylix/Stylix.json".text = lib.mkDefault (
        builtins.toJSON (with config.lib.stylix.colors.withHashtag; {
          dark = {
            name = "Stylix";
            primary = base0D;
            primaryText = base00;
            primaryContainer = base0C;
            secondary = base0E;
            surface = base01;
            surfaceText = base05;
            surfaceVariant = base02;
            surfaceVariantText = base04;
            surfaceTint = base0D;
            background = base00;
            backgroundText = base05;
            outline = base03;
            surfaceContainer = base01;
            surfaceContainerHigh = base02;
            surfaceContainerHighest = base03;
            error = base08;
            warning = base0A;
            info = base0C;
          };
          light = {
            name = "Stylix";
            primary = base0D;
            primaryText = base07;
            primaryContainer = base0C;
            secondary = base0E;
            surface = base06;
            surfaceText = base02;
            surfaceVariant = base05;
            surfaceVariantText = base03;
            surfaceTint = base0D;
            background = base07;
            backgroundText = base02;
            outline = base04;
            surfaceContainer = base06;
            surfaceContainerHigh = base05;
            surfaceContainerHighest = base04;
            error = base08;
            warning = base0A;
            info = base0C;
          };
        })
      );
    };
  };
}
