{ config, lib, pkgs, ... }:

with lib;

{
  options.modules.desktop.gnome = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable GNOME DE";
    };
    xrdp = mkOption {
      type = types.bool;
      default = true;
      description = "Enable XRDP";
    };
  };

  config = mkIf config.modules.desktop.gnome.enable {
    services.xserver.enable = true;
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;
    services.gnome.gnome-remote-desktop.enable = false;

    # Configure keymap in X11
    # services.xserver.xkb = {
    #   layout = "us";
    #   variant = "";
    # };

    # Enable XRDP
    services.xrdp = mkIf config.modules.desktop.gnome.xrdp {
      enable = true;
      defaultWindowManager = "${pkgs.gnome-session}/bin/gnome-session";
      openFirewall = true;
    };

    environment.systemPackages = mkIf config.modules.desktop.gnome.xrdp
      (with pkgs; [ pipewire-module-xrdp ]);

    # Disable the GNOME3/GDM auto-suspend feature that cannot be disabled in GUI!
    # If no user is logged in, the machine will power down after 20 minutes.
    systemd.targets.sleep.enable = false;
    systemd.targets.suspend.enable = false;
    systemd.targets.hibernate.enable = false;
    systemd.targets.hybrid-sleep.enable = false;
  };
}
