{ config, lib, pkgs, ... }:

with lib;

{
  options.modules.utils.persistence = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable persistence using nix-community/impermanence";
    };
  };

  config = mkIf config.modules.utils.persistence.enable {
    environment.persistence."/persist" = {
      enable = true;
      hideMounts = true;

      directories = [
        "/var/log"
        "/var/lib/bluetooth"
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
        "/etc/NetworkManager/system-connections"
        "/var/lib/docker"
        "/etc/ssh"
        "/etc/pki"
        "/var/lib/containers"
      ];

      files = [ "/etc/machine-id" ];
    };
  };
}
