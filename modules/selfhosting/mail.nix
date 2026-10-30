_: {
  flake.modules.selfhosting."mail" = {
    config,
    lib,
    ...
  }: let
    dkim = config.services.opendkim;
    dkimSocket = "unix:/run/opendkim/opendkim.sock";
  in {
    age.secrets.dkim-key = {
      file = ../../secrets/dkim-key.age;
      path = "${dkim.keyPath}/${dkim.selector}.private";
      symlink = false;
      owner = dkim.user;
      inherit (dkim) group;
    };

    services.postfix = {
      enable = true;
      rootAlias = "matetamasi@protonmail.com";
      postmasterAlias = "root";
      settings.main = {
        myhostname = "tamasi.dev";
        mydomain = "tamasi.dev";
        myorigin = "tamasi.dev";
        mydestination = ["localhost"];
        inet_interfaces = "loopback-only";
        mynetworks = ["127.0.0.0/8" "[::1]/128"];
        smtpd_relay_restrictions = ["permit_mynetworks" "reject"];

        smtp_tls_security_level = "may";
        smtp_tls_loglevel = "1";

        smtpd_milters = [dkimSocket];
        non_smtpd_milters = [dkimSocket];
        milter_default_action = "accept";
      };
    };

    services.opendkim = {
      enable = true;
      selector = "mail";
      domains = "csl:tamasi.dev";
      settings.UMask = "0007";
    };
    users.users.postfix.extraGroups = [dkim.group];
  };
}
