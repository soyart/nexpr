{ lib, config, pkgs, username, ... }:

with lib;
with lib.types;

let
  cfg = config.nexpr.langs.go;
  goBase = with pkgs; [ go gopls ];

in {
  config = mkIf cfg.enable {
    environment.systemPackages =
      mkIf cfg.systemPackage goBase;

    home-manager.users."${username}".home.packages =
      mkIf (!cfg.systemPackage) goBase;
  };
}
