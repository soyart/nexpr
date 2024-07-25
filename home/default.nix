{ inputs, ... }:

let
  inherit (inputs) nixpkgs home-manager;

  mkHome = {
    modules,
    username,
    stateVersion ? "23.11",
    system ? "x86_64-linux",
  }: home-manager.lib.homeManagerConfiguration {
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    inherit modules;
    extraSpecialArgs = { inherit inputs username stateVersion; };
  };
in {
  "artnoi@nexpr-t14" = mkHome {
    username = "artnoi";
    modules = [
      ../defaults/hm.nix
      ../presets/sway-dev
    ];
  };
}
