_: {
  flake.modules.common."secrets" = {config, ...}: {
    # Secrets
    age = {
      identityPaths = [
        "/etc/ssh/ssh_host_ed25519_key"
        "/persist/etc/ssh/ssh_host_ed25519_key"
      ];
    };
  };
}
