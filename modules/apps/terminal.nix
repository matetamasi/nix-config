{inputs, ...}: {
  flake.modules.nixos."terminal" = {
    config,
    lib,
    pkgs,
    ...
  }: {
    fonts.packages = with pkgs; [
      nerd-fonts._0xproto
    ];

    home-manager.users.${config.user.name} = _: {
      programs.ghostty = {
        enable = true;
        enableZshIntegration = true;
        systemd.enable = true;
        settings = {
          theme = "dankcolors";
          cursor-style = "block";
          custom-shader = "shaders/cursor_sweep.glsl";
          mouse-scroll-multiplier = "precision:0.2,discrete:0.75";
          font-family = "0xProto Nerd Font";
        };
      };
    };
  };
}
