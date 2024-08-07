{ lib, config, ... }:

with lib;
with lib.types;

let
  cfg = config.los.net.iwd;

in {
  options.los.net.iwd = {
    enable =  mkEnableOption "Enable iwd wireless daemon";
  };

  config = mkIf cfg.enable {
    networking.wireless.iwd = {
      enable = true;
      settings = {
        Settings = {
          AutoConnect = true;
        };
      };
    };
  };
}
