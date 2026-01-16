{ lib, config, ... }:

with lib;

{
  options.modules.services.vikunja = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Vikunja with PostgreSQL and SMTP";
    };
  };

  config = mkIf config.modules.services.vikunja.enable {
    services.vikunja = {
      enable = true;
      frontendScheme = "http";
      frontendHostname = "vikunja.begad.dev";
      database = {
        type = "postgres";
        host = "localhost";
      };
      settings = {
        service = { enableregistration = false; };
        mailer = {
          enabled = true;
          host = "smtp.resend.com";
          username = "resend";
          password.file = config.sops.secrets.vikunja_resend_api_key.path;
          fromemail = "vikunja@mail.mivern.net";
        };
      };
    };
    sops.secrets.vikunja_resend_api_key = {
      owner = "vikunja";
      group = "vikunja";
    };
  };
}
