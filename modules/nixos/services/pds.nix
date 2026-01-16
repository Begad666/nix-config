{ lib, config, ... }:

with lib;

{
  options.modules.services.pds = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable PDS";
    };
  };

  config = mkIf config.modules.services.pds.enable {
    services.pds = {
      enable = true;
      settings = {
        PDS_HOSTNAME = "pds.mivern.net";
        PDS_PORT = 4040;
      };
    };
  };
}
