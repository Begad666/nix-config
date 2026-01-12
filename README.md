# nix-config

This repo contains the Nix flake and configurations used for all my home-manager/NixOS installations

## structure

- `/hosts`

  Contains NixOS configurations, in directories named after the host's purpose.
  Each host directory should contain a `./configuration.nix`, and optionally a `users` directory if needed.

  Additional nix modules per host is allowed, but prefer extracting to shared directories if possible.
  Same goes for `./configuration.nix`.

- `/hosts/<host>/users`

  Contains home-manager configurations for users of the host.
  Each user directory should contain a `./home.nix` file.

  Additional nix modules per user is allowed, but prefer extracting to shared directories if possible.
  Same goes for `./home.nix`

- `/users`

  Contains shared home-manager configurations, for shared users.
  Same guidelines as per-host users apply.

- `/modules/nixos`

  No idea lol.

- `/modules/home-manager`

  No idea lol.

- `/pkgs`

  Contains custom packages.

- `/overlays`

  Contains overlays of nixpkgs.

- `/secrets`

  SOPS-encrypted secrets live here.

  `default.yaml` is for any general secrets, but separate files can also be used, if needed.

- `/utils`, `/services`, etc.

  Modules intended for use in configurations.

## sops

If adding a new server, then first import the GPG key, do `nixos-rebuild switch`, get the age public key, then add the key in the sops config and commit the re-encrypted secrets.
Afterwards, delete the GPG key if needed.
