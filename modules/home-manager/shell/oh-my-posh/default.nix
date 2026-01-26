{ config, lib, pkgs, ... }:

with lib;

{
  options.modules.shell.oh-my-posh = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable oh-my-posh";
    };
    config = mkOption {
      type = types.str;
      default = "main";
      description = "oh-my-posh config to use";
    };
  };

  config = mkIf config.modules.shell.oh-my-posh.enable {
    programs.oh-my-posh = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      configFile = ./. + "/${config.modules.shell.oh-my-posh.config}.omp.json";
    };
  };
}
