{ config, lib, pkgs, ... }:

with lib;

let caelestiaConfigDir = ./.;
in {
  options.modules.desktop.caelestia = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Caelestia";
    };
  };

  config = mkIf config.modules.desktop.caelestia.enable {
    programs.caelestia = {
      enable = true;
      systemd = {
        enable = false; # if you prefer starting from your compositor
        target = "graphical-session.target";
        environment = [ ];
      };
      settings = {
        bar.status = { showBattery = false; };
        paths.wallpaperDir = "~/Images";
      };
      cli = {
        enable = true; # Also add caelestia-cli to path
        settings = { theme.enableGtk = false; };
      };
    };
    # home.packages = with pkgs; [ caelestia-cli ];
    # xdg.configFile."caelestia/shell.json".source = caelestiaConfigDir
    #   + "/shell.json";
    # xdg.stateFile."caelestia/wallpaper/path.txt".source = caelestiaConfigDir
    #   + "/path.txt";
  };
}
