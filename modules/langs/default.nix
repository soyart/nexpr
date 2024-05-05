{ lib, ... }:

with lib;
with lib.types;

let
  mod = {
    options = {
      enable = mkEnableOption "Enable language support";
      systemPackage = mkEnableOption "Enable language support as system package";
    };
  };

in {
  imports = [
    ./go
    ./rust
  ];

  options.nexpr.langs = mkOption {
      description = "Programming languages to install. See subdirectories of this module for supported languages";
      type = attrsOf (submodule mod);
      default = {
        enable = false;
        systemPackage = false;
      };
  };

  # @TODO: Config simple languages here
}
