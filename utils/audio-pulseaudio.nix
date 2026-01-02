{ config, lib, pkgs, ... }:

{
  services.pipewire.enable = false;
  services.pulseaudio = {
    enable = true;
    support32Bit = true;
  };
}
