# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  # Enable custom modules
  modules = {
    audio.pipewire.enable = true;
    gaming.discord.enable = true;
    gaming.steam.enable = true;
    services.cloudflared.enable = true;
    services.docker.enable = true;
    # services.postgresql.enable = true;
    # services.vikunja.enable = true;
    utils.i18n.enable = true;
    utils.nvidia.enable = true;
    utils.secrets.enable = true;
    utils.persistence.enable = true;
  };

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix = let flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
    # Opinionated: disable channels
    channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.useDHCP = lib.mkDefault true;
  networking.hostName = "homelab";
  networking.hostId = "be392f4e";
  boot.initrd.postDeviceCommands = ''
    mkdir -p /mnt/keys
    mount /dev/mapper/crypt-keys /mnt/keys
    echo "[initrd] postDeviceCommands done"
  '';
  boot.initrd.postMountCommands = ''
    umount /mnt/keys
    /sbin/cryptsetup close crypt-keys
    echo "[initrd] postMountCommands done"
  '';
  boot.initrd.luks.devices."crypt-keys" = {
    device = "/dev/disk/by-uuid/68b58f46-e2fa-45ed-8585-eb4fc826dd6a";
    bypassWorkqueues = true;
  };
  boot.initrd.luks.devices."crypt-nixos" = {
    device = "/dev/disk/by-uuid/3a538d1b-c8b1-42c3-8676-65f9455da504";
    bypassWorkqueues = true;
  };
  boot.initrd.luks.devices."crypt-swap" = {
    device = "/dev/disk/by-uuid/e5b4f2e9-9909-48fa-9b91-e31e38b546ff";
    bypassWorkqueues = true;
  };
  # Risky, but allows for hibernation with ZFS
  # boot.zfs.allowHibernation = true;
  # boot.kernelParams =
  #   [ "zfs.zfs_arc_max=4294967296" "resume=/dev/mapper/crypt-swap" ];
  boot.kernelParams = [ "zfs.zfs_arc_max=4294967296" ];

  fileSystems."/boot".options = [ "fmask=0077" "dmask=0077" "umask=0077" ];

  fileSystems."/persist".neededForBoot = true;

  # Enable networking
  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [ home-manager ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.begad = {
    isNormalUser = true;
    description = "***REMOVED***";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    openssh.authorizedKeys.keys = [
      # main device ssh key
      # should do this better, but whatever for now
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAsdRXkk6FdV65sAa+4Yy7PfjNuwVB8AvKgwZ8x/6xZ7 47504169+Begad666@users.noreply.github.com"
    ];
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 3389 5432 ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  programs.nix-ld.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.11";
}
