# https://github.com/nix-community/impermanence#module-usage
{
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
    ];
    files = [
      "/etc/machine-id" # for journalctl
    ];
    users.matetamasi = {
      directories = [
        ".local/share/kscreen"
        ".local/share/kwalletd"
        ".local/share/sddm"
        ".local/share/zoxide"
        "Downloads"
      ];
      files = [
        ".bash_history"
        ".config/systemsettingsrc"
        ".zsh_history"
      ];
    };
  };
}

