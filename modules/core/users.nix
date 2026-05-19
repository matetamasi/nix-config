{lib, ...}: {
  flake.modules.nixos."users" = {
    pkgs,
    config,
    lib,
    ...
  }: {
    options.user.name = lib.mkOption {
      type = lib.types.str;
      default = "matetamasi";
      description = "The primary user's name";
    };

    config = {
      users.mutableUsers = false;
      users.users = {
        root.hashedPasswordFile = "/persist/passwords/root.pass";

        ${config.user.name} = {
          hashedPasswordFile = "/persist/passwords/${config.user.name}.pass";
          isNormalUser = true;
          description = "Tamási Máté";
          extraGroups = ["networkmanager" "wheel"];
          shell = pkgs.zsh;
        };
      };
    };
  };
}
