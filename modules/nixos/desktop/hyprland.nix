{ config, lib, pkgs, ... }:

with lib;

{
  options.modules.desktop.hyprland = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Hyprland with SDDM (no configuration)";
    };
  };

  config = mkIf config.modules.desktop.hyprland.enable {
    services.xserver.enable = true;
    services.displayManager.sddm = {
      enable = true;
      package = pkgs.kdePackages.sddm;
      extraPackages = with pkgs.kdePackages; [
        qtmultimedia
        qtsvg
        qtvirtualkeyboard
      ];
      wayland.enable = true;
    };
    programs.hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
