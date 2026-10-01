{ config, lib, pkgs, ... }:

with lib;

{
  options.modules.services.openssh = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable OpenSSH server with default configuration";
    };
  };

  config = mkIf config.modules.services.openssh.enable {
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "prohibit-password";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
    networking.firewall.allowedTCPPorts = [ 22 ];
  };
}
