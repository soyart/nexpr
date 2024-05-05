{ lib, config, pkgs, username, ... }:

with lib;
with lib.types;

let
  cfgLang = config.nexpr.langs;
  cfg = cfgLang.rust;

  rustBase = with pkgs; [ cargo rust-analyzer ];

in {
  config = mkIf (
    builtins.hasAttr "rust" cfgLang
    &&
    cfg.enable
  ) {
    environment.systemPackages =
      mkIf cfg.systemPackage rustBase;

    home-manager.users."${username}".home.packages =
      mkIf (!cfg.systemPackage) rustBase;
  };
}
