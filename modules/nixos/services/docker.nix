{ config, lib, pkgs, ... }:

with lib;

{
  options.modules.services.docker = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Docker with docker-compose";
    };
  };

  config = mkIf config.modules.services.docker.enable {
    virtualisation.docker.enable = true;
    virtualisation.docker.enableOnBoot = true;
    environment.systemPackages = with pkgs; [ docker-compose ];
  };
}
