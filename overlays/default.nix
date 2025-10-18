# This file defines overlays
{ inputs, ... }: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final.pkgs;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # TODO: fix this
    vikunja = prev.vikunja.overrideAttrs (old: {
      src = prev.fetchFromGitHub {
        owner = "go-vikunja";
        repo = "vikunja";
        rev = "7b626cd2f565dfcf7aa23cc1e098bc1fcd134dde";
        hash = "sha256-xBJXKUs3Q+RPYOayLX5TO4PzckuLXutucY38NCpJ2o4=";
      };
    });
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
