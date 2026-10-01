{ config, lib, pkgs, ... }:

with lib;

{
  # TODO: Add options for samba usershares, and for samba-wsdd (which is needed for windows discovery)
	options.modules.services.samba = {
		enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Samba";
		};
	};

  config = mkIf config.modules.services.samba.enable {
    services.samba = {
      enable = true;
      openFirewall = true;
      package = pkgs.samba4Full;
      usershares.enable = true;
      settings = {
        global = {
          "workgroup" = "WORKGROUP";
          "server string" = "homelab";
          "netbios name" = "homelab";
          "security" = "user";
          #"use sendfile" = "yes";
          #"max protocol" = "smb2";
          # note: localhost is the ipv6 localhost ::1
          "hosts allow" = "192.168.0. 127.0.0.1 localhost";
          "hosts deny" = "0.0.0.0/0";
          "guest account" = "nobody";
          "map to guest" = "bad user";
        };
        "public" = {
          "path" = "/run/mount/secondary/public";
          "browseable" = "yes";
          "read only" = "no";
          "guest ok" = "yes";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "nobody";
          "force group" = "nogroup";
        };
        "private" = {
          "path" = "/run/mount/secondary/private";
          "browseable" = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0644";
          "directory mask" = "0755";
          "valid users" = "begad";
        };
      };
    };

    # To be discoverable with windows
    services.samba-wsdd = {
      enable = true;
      openFirewall = true;
    };

    services.avahi = {
      publish.enable = true;
      publish.userServices = true;
      # ^^ Needed to allow samba to automatically register mDNS records (without the need for an `extraServiceFile`
      nssmdns4 = true;
      # ^^ Not one hundred percent sure if this is needed- if it aint broke, don't fix it
      enable = true;
      openFirewall = true;
    };

    networking.firewall.enable = true;
    networking.firewall.allowPing = true;
  };
}
