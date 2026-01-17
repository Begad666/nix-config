{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [ ../../../../users/begad/home.nix ];

  modules = { desktop.caelestia.enable = true; };
}
