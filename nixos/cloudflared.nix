{ config, lib, pkgs, ... }:

{
  services.cloudflared = {
    enable = true;
    # TODO: why does it error with a different user?
    user = "begad";
    tunnels = {
      "9eebc7a4-5eee-42f9-b31f-30b73ad751e0" = {
        # TODO: use sops for this
        credentialsFile = "/home/begad/nixos/server/secrets/cloudflare-tunnel.json";
        default = "http_status:404";
      };
    };
  };

  # Increase UDP buffer sizes for quic-go
  boot.kernel.sysctl."net.core.rmem_max" = 7500000;
  boot.kernel.sysctl."net.core.wmem_max" = 7500000;
}
