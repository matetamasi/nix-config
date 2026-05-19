{...}: {
  flake.modules.nixos."browser" = {
    inputs,
    pkgs,
    config,
    lib,
    ...
  }: {
    environment.persistence."/persist".users.${config.user.name}.directories = lib.mkIf config.features.impermanence.enable [
      ".zen" # Zen browser
    ];

    home-manager.users.${config.user.name} = {
      # Nixpkgs config within Home Manager
      nixpkgs.config.allowUnfree = true;

      home.packages = [
        inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.beta
      ];

      # Default applications
      xdg.mimeApps = {
        enable = true;

        defaultApplications = {
          "text/html" = "zen-beta.desktop";
          "x-scheme-handler/http" = "zen-beta.desktop";
          "x-scheme-handler/https" = "zen-beta.desktop";
          "x-scheme-handler/about" = "zen-beta.desktop";
          "x-scheme-handler/unknown" = "zen-beta.desktop";
        };
      };
    };
  };
}
