{ config, lib, pkgs, ... }:

with lib;

{
  options.modules.desktop.caelestia = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Caelestia";
    };
  };

  config = mkIf config.modules.desktop.caelestia.enable {
    programs.caelestia-dots.enable = true;
  };
}
