_: {
  flake.modules.common."terminal" = {
    config,
    lib,
    pkgs,
    ...
  }: {
    fonts.packages = with pkgs; [
      nerd-fonts._0xproto
    ];

    home-manager.users.${config.user.name} = {
      home.sessionVariables.TERM = "ghostty";

      programs.ghostty = {
        enable = true;
        enableZshIntegration = true;
        systemd.enable = true;
        settings = {
          cursor-style = "block";
          custom-shader = "shaders/cursor_sweep.glsl";
          mouse-scroll-multiplier = "precision:0.2,discrete:0.75";
          font-family = "0xProto Nerd Font";

          keybind = [
            "ctrl+plus=increase_font_size:1"
            "ctrl+numpad_add=increase_font_size:1"
            "ctrl+shift+equal=increase_font_size:1"
            "ctrl+shift+plus=increase_font_size:1"
          ];
        };
      };
    };
  };
}
