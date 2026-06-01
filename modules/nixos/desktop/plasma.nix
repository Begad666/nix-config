{ config, lib, pkgs, ... }:

with lib;

{
  options.modules.desktop.plasma = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Plasma DE";
    };
    xrdp = mkOption {
      type = types.bool;
      default = true;
      description = "Enable XRDP";
    };
  };

  config = mkIf config.modules.desktop.plasma.enable {
    services.xserver.enable = true;
	services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;

    # Configure keymap in X11
    # services.xserver.xkb = {
    #   layout = "us";
    #   variant = "";
    # };

    # Enable XRDP
    services.xrdp = mkIf config.modules.desktop.plasma.xrdp {
      enable = true;
      defaultWindowManager = "${pkgs.kdePackages.plasma-workspace}/bin/startplasma-x11";
      openFirewall = true;
    };

    environment.systemPackages = mkIf config.modules.desktop.plasma.xrdp
      (with pkgs; [ pipewire-module-xrdp ]);

	systemd.targets.sleep.enable = false;
    systemd.targets.suspend.enable = false;
    systemd.targets.hibernate.enable = false;
    systemd.targets.hybrid-sleep.enable = false;
  };
}
