{ config, lib, pkgs, ... }:

with lib;

{
  options.modules.shell.zsh = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable bash";
    };
  };

  config =
    mkIf config.modules.shell.zsh.enable { programs.zsh = { enable = true; }; };
}
