# Add your reusable home-manager modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{
  # Desktop modules
  desktop-caelestia = import ./desktop/caelestia/default.nix;

  # Shell modules
  shell-bash = import ./shell/bash.nix;
  shell-zsh = import ./shell/zsh.nix;
  shell-oh-my-posh = import ./shell/oh-my-posh.nix;

  # Utility modules
  utils-gc = import ./utils/gc.nix;
}
