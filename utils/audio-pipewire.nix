{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ pulseaudio pavucontrol helvum ];

  security.rtkit.enable = true;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  services.pipewire.extraConfig.pipewire = {
    "10-dummy-objects" = {
      "context.objects" = [
        {
          # A default dummy driver. This handles nodes marked with the "node.always-driver"
          # property when no other driver is currently active. JACK clients need this.
          factory = "spa-node-factory";
          args = {
            "factory.name" = "support.node.driver";
            "node.name" = "Dummy-Driver";
            "priority.driver" = 8000;
          };
        }
        {
          factory = "adapter";
          args = {
            "factory.name" = "support.null-audio-sink";
            "node.name" = "Dummy-Input";
            "node.description" = "Dummy Input";
            "media.class" = "Audio/Source/Virtual";
            "audio.position" = "MONO";
          };
        }
        {
          factory = "adapter";
          args = {
            "factory.name" = "support.null-audio-sink";
            "node.name" = "Dummy-Output";
            "node.description" = "Dummy Output";
            "media.class" = "Audio/Sink";
            "audio.position" = "FL,FR";
          };
        }
      ];
    };
    "11-latency" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 128;
        "default.clock.min-quantum" = 128;
        "default.clock.max-quantum" = 128;
      };
    };
  };
  services.pipewire.extraConfig.pipewire-pulse = {
    "10-latency" = {
      context.modules = [{
        name = "libpipewire-module-protocol-pulse";
        args = {
          pulse.min.req = "128/48000";
          pulse.default.req = "128/48000";
          pulse.max.req = "128/48000";
          pulse.min.quantum = "128/48000";
          pulse.max.quantum = "128/48000";
        };
      }];
      stream.properties = {
        node.latency = "128/48000";
        resample.quality = 1;
      };
    };
  };
}
