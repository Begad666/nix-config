{ config, lib, pkgs, ... }:

with lib;

{
  options.modules.gaming.discord = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Discord";
    };
  };

  config = mkIf config.modules.gaming.discord.enable {
    environment.systemPackages = with pkgs; [ discord ];
  };
}
