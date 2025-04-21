{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ age ssh-to-age sops ];
  sops = {
    defaultSopsFile = ../secrets/default.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  };
}
