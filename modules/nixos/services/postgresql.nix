{ lib, config, pkgs, ... }:

with lib;

{
  options.modules.services.postgresql = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable PostgreSQL";
    };
  };

  config = mkIf config.modules.services.postgresql.enable {
    services.postgresql = {
      enable = true;
      enableTCPIP = true;
      ensureDatabases = [ "vikunja" "enjazi" ];
      authentication = pkgs.lib.mkOverride 10 ''
        #...
        #type database DBuser origin-address auth-method
        local all      all                   trust
        # ipv4
        host  all      all    127.0.0.1/32   trust
        # ipv6
        host  all      all    ::1/128        trust
        # allow LAN (require password)
        host  all       all    192.168.0.0/24 md5

      '';
      ensureUsers = [
        {
          name = "vikunja";
          ensureDBOwnership = true;
        }
        {
          name = "enjazi";
          ensureDBOwnership = true;
        }
      ];
    };
  };
}
