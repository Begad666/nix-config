{ config, lib, pkgs, ... }:

with lib;

{
  options.modules.utils.secrets = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable SOPS secrets management with age encryption";
    };
  };

  config = mkIf config.modules.utils.secrets.enable {
    environment.systemPackages = with pkgs; [ age ssh-to-age sops ];
    sops = {
      defaultSopsFile = ../../../secrets/default.yaml;
      age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    };
  };
}
