{ config, lib, pkgs, ... }:

with lib;

{
  options.modules.utils.persistence = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable persistence using nix-community/impermanence";
    };

	directories = mkOption {
	  type = types.listOf types.str;
	  default = [ ];
	  description = "List of directories to persist, in addition to the default ones. These will be symlinked to /persist.";
	};

	files = mkOption {
	  type = types.listOf types.str;
	  default = [ ];
	  description = "List of files to persist, in addition to the default ones. These will be symlinked to /persist.";
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
      ] ++ config.modules.utils.persistence.directories;

      files = [ "/etc/machine-id" ] ++ config.modules.utils.persistence.files;
    };
  };
}
