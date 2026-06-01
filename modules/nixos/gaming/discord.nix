{ config, lib, pkgs, ... }:

with lib;

{
  options.modules.gaming.discord = {
    stable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Discord";
    };
	ptb = mkOption {
	  type = types.bool;
	  default = false;
	  description = "Enable Discord PTB";
	};
	canary = mkOption {
	  type = types.bool;
	  default = false;
	  description = "Enable Discord Canary";
	};
  };

  config = mkIf (config.modules.gaming.discord.stable || config.modules.gaming.discord.ptb || config.modules.gaming.discord.canary) {
    environment.systemPackages = (if config.modules.gaming.discord.stable then [ pkgs.discord ] else []) ++
	  (if config.modules.gaming.discord.ptb then [ pkgs.discord-ptb ] else []) ++
	  (if config.modules.gaming.discord.canary then [ pkgs.discord-canary ] else []);
  };
}
