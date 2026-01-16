{ config, lib, ... }:

with lib;

{
  options.modules.utils.i18n = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description =
        "Enable internationalization settings (timezone and locale)";
    };
  };

  config = mkIf config.modules.utils.i18n.enable {
    # Set your time zone.
    time.timeZone = "Asia/Riyadh";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "ar_SA.UTF-8";
      LC_IDENTIFICATION = "ar_SA.UTF-8";
      LC_MEASUREMENT = "ar_SA.UTF-8";
      LC_MONETARY = "ar_SA.UTF-8";
      LC_NAME = "ar_SA.UTF-8";
      LC_NUMERIC = "ar_SA.UTF-8";
      LC_PAPER = "ar_SA.UTF-8";
      LC_TELEPHONE = "ar_SA.UTF-8";
      LC_TIME = "ar_SA.UTF-8";
    };
  };
}
