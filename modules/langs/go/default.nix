{ lib, config, pkgs, username, ... }:

with lib;
with lib.types;

let
  cfg = config.nexpr.langs.go;
  goBase = with pkgs; [ go gopls ];

in {
  options = {
    nexpr.langs.go = {
      enable = mkEnableOption ''
        Enable Go language support.
        This option will install `go` and `gopls` to user home-manager.
      '';

      systemPackage = mkEnableOption ''
        Enable Go language support.
        This option will add `go` and `gopls` to system packages instead of home-manager.
        You must set enable = true before setting systemPackage = true.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages =
      mkIf cfg.systemPackage goBase;

    home-manager.users."${username}".home.packages =
      mkIf (!cfg.systemPackage) goBase;
  };
}
