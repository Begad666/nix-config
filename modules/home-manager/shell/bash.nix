{ config, lib, pkgs, ... }:

with lib;

{
  options.modules.shell.bash = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable bash";
    };
  };

  config = mkIf config.modules.shell.bash.enable {
    programs.bash = { enable = true; };
  };
}
