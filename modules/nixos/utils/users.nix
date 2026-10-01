{ config, lib, pkgs, ... }:

with lib;

{
  options.modules.utils.users.begad = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable the default begad user";
    };
  };

  config = mkIf config.modules.utils.users.begad.enable {
    users.users.begad = {
      isNormalUser = true;
      description = "begad";
      extraGroups = mkMerge [
        [ "networkmanager" "wheel" ]
        (mkIf config.modules.utils.persistence.enable [ "docker" ])
      ];
      openssh.authorizedKeys.keys = [
        # main device ssh key
        # should do this better, but whatever for now
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAsdRXkk6FdV65sAa+4Yy7PfjNuwVB8AvKgwZ8x/6xZ7 47504169+Begad666@users.noreply.github.com"
      ];
    };
  };
}
