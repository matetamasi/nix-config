_: {
  flake.modules.raserei."user-auth" = {config, ...}: {
    age.secrets = {
      matetamasi-password = {
        file = ../../../secrets/raserei-matetamasi-password.age;
        owner = "root";
        group = "root";
      };
      root-password = {
        file = ../../../secrets/raserei-root-password.age;
        owner = "root";
        group = "root";
      };
    };
    users.users = {
      root.hashedPasswordFile = config.age.secrets.root-password.path;
      ${config.user.name}. hashedPasswordFile = config.age.secrets.matetamasi-password.path;
    };
  };
}
