{ config, lib, ... }:

with lib;

{
  options.modules.gaming.steam = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Steam with remote play and network game transfers";
    };
  };

  config = mkIf config.modules.gaming.steam.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall =
        true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall =
        true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall =
        true; # Open ports in the firewall for Steam Local Network Game Transfers
    };
  };
}
