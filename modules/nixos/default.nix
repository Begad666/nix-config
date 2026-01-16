# Add your reusable NixOS modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{
  # Audio modules
  audio-pipewire = import ./audio/pipewire.nix;
  audio-pulseaudio = import ./audio/pulseaudio.nix;

  # Service modules
  services-cloudflared = import ./services/cloudflared.nix;
  services-docker = import ./services/docker.nix;
  services-pds = import ./services/pds.nix;
  services-postgresql = import ./services/postgresql.nix;
  services-vikunja = import ./services/vikunja.nix;

  # Utility modules
  utils-desktop = import ./utils/desktop.nix;
  utils-i18n = import ./utils/i18n.nix;
  utils-nvidia = import ./utils/nvidia.nix;
  utils-secrets = import ./utils/secrets.nix;

  # Gaming modules
  gaming-discord = import ./gaming/discord.nix;
  gaming-steam = import ./gaming/steam.nix;
}
