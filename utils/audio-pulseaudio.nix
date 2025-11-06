{ config, lib, pkgs, ... }:

{
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;
}
