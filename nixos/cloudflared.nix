{ config, lib, pkgs, ... }:

{
  services.cloudflared = {
    enable = true;
    tunnels = {
      "9eebc7a4-5eee-42f9-b31f-30b73ad751e0" = {
        credentialsFile = config.sops.secrets.cloudflare-tunnel.path;
        default = "http_status:404";
      };
    };
  };

  sops.secrets.cloudflare-tunnel = {
    owner = services.cloudflared.user;
    group = services.cloudflared.group;
    format = "json";
    sopsFile = ../secrets/cloudflare-tunnel.json;
    key = "";
  };

  # Increase UDP buffer sizes for quic-go
  boot.kernel.sysctl."net.core.rmem_max" = 7500000;
  boot.kernel.sysctl."net.core.wmem_max" = 7500000;
}
