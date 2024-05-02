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

      nerdFonts = mkOption {
        description = "Nerd Fonts";
        type = listOf package;
        default = with pkgs; [
          hack-font
        ];
        example = with pkgs; [
          inconsolata
          hack-font
        ];
      };

      familyDefaults = let example = [
        "Ubuntu"
        "Inconsolata"
      ];
      in {
        serif = mkOption {
          description = "List of font names (not package names)";
          type = listOf str;
          default = [];
          inherit example;
        };
        sansSerif = mkOption {
          description = "List of font names (not package names)";
          type = listOf str;
          default = [];
          inherit example;
        };
        monospace = mkOption {
          description = "List of font names (not package names)";
          type = listOf str;
          default = [];
          inherit example;
        };
      };
    };
  };

  config = mkIf cfg.enable {
    fonts = let
      fontsNerd = (nerdfonts.override {
        fonts = cfg.nerdFonts;
      });
    in {
      packages = cfg.ttf ++ fontsNerd;
      
      fontconfig = {
        defaultFonts = cfg.familyDefaults;
      };
    };
  };
}
