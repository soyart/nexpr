{ lib, config, ... }:

with lib;
with lib.types;

let
  cfg = config.unboundDoT;

in
{
  options = {
    unboundDoT.enable = mkDefault "Enable DNS-over-TLS with unbound";
    unboundDot.hosts = mkOption {
      type = listOf str;
      example = ["1.1.1.1" "9.9.9.9"];
      default = [];
      description = "";
    };
  };

  config = mkIf cfg.enable {
    
  };
}
