{ config, lib, pkgs, ... }: {
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.gnome.gnome-remote-desktop.enable = false;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  environment.systemPackages = with pkgs; [ pipewire-module-xrdp ];

  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager =
    "${pkgs.gnome-session}/bin/gnome-session";
  services.xrdp.openFirewall = true;
  services.pipewire.extraConfig.pipewire = {
    xrdp = {
      context.modules = [{
        name = "libpipewire-module-xrdp";
        args = {
          sink.node.latency = 2048;
          sink.stream.props = { node.name = "xrdp-sink"; };
          source.stream.props = { node.name = "xrdp-source"; };
        };
      }];
    };
  };

  # Disable the GNOME3/GDM auto-suspend feature that cannot be disabled in GUI!
  # If no user is logged in, the machine will power down after 20 minutes.
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;
}
