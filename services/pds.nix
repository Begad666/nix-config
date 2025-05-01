{ inputs, outputs, lib, config, pkgs, ... }:
{
  services.pds = {
    enable = true;
    settings = {
      PDS_HOSTNAME = "pds.mivern.net";
      PDS_PORT = 4040;
    }
  }
}
