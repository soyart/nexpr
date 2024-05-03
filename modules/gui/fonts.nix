{ lib, config, pkgs, ... }:

with lib;
with lib.types;

let
  cfg = config.nexpr.gui.fonts;

in {
  options = {
    nexpr.gui.fonts = {
      enable = mkEnableOption "Install fonts for GUI";

      ttf = mkOption {
        description = "Normal TTF fonts";
        type = listOf package;
        default = with pkgs; [
          inconsolata
          liberation_ttf
        ];
        example = with pkgs; [
          inconsolata
          liberation_ttf
        ];
      };

      nerd = mkOption {
        description = "Nerd Fonts for override";
        type = listOf str;
        default = [];
        example = [
          "Hack"
          "Inconsolata"
        ];
      };

      # familyDefaults = let example = [
      #   "Ubuntu"
      # ];
      # in {
      #   serif = mkOption {
      #     description = "List of font names (not package names)";
      #     type = str;
      #     inherit example;
      #   };
      #   sansSerif = mkOption {
      #     description = "List of font names (not package names)";
      #     type = str;
      #     inherit example;
      #   };
      #   monospace = mkOption {
      #     description = "List of font names (not package names)";
      #     type = str;
      #     inherit example;
      #   };
      # };
    };
  };

  config = mkIf cfg.enable {
    fonts = let
      fontsNerd = [
        (pkgs.nerdfonts.override { fonts = cfg.nerd; })
      ];
      
    in {
      packages = cfg.ttf ++ fontsNerd;
    };
  };
}
