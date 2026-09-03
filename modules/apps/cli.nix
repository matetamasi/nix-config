_: {
  flake.modules.common."cli" = {
    pkgs,
    inputs,
    config,
    lib,
    ...
  }: {
    environment.systemPackages = with pkgs; [
      ripgrep
      file
      vim
      tree
      coreutils-full
      pciutils
      lshw
      fastfetch
      htop-vim
      libsecret
      inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    # Home Manager
    home-manager.users.${config.user.name} = {
      home = {
        packages = with pkgs; [
          bat
          zoxide
          (hunspell.withDicts (ds: [ds.en_US-large]))
        ];
        sessionVariables.EDITOR = lib.mkDefault "vim";
      };

      xdg.configFile."htop/htoprc".source = ../../resources/htop/htoprc;
    };
  };
}
