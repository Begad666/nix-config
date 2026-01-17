{ config, lib, pkgs, ... }:

with lib;

{
  options.modules.utils.gc = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable garbage collection";
    };
  };

  config = mkIf config.modules.utils.gc.enable {
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
