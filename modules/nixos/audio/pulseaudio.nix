{ config, lib, ... }:

with lib;

{
  options.modules.audio.pulseaudio = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable PulseAudio sound server";
    };
  };

  config = mkIf config.modules.audio.pulseaudio.enable {
    services.pipewire.enable = false;
    services.pulseaudio = {
      enable = true;
      support32Bit = true;
    };
  };
}
