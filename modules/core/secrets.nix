_: {
  flake.modules.nixos."secrets" = {config, ...}: {
    # Secrets
    age = {
      identityPaths = ["/persist/etc/ssh/ssh_host_ed25519_key"];
      secrets.eduroam = {
        file = ../../secrets/eduroam.env.age;
        owner = "root";
        group = "root";
      };
    };
  };
}
