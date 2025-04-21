{ config, lib, pkgs, ... }:

{
  virtualisation.docker.enable = true;
  virtualisation.docker.enableOnBoot = true;
  environment.systemPackages = with pkgs; [
    docker-compose
  ];
}
