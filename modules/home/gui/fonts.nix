username:

{ lib, config, pkgs, ... }:

with lib;
with lib.types;

let
  cfg = config.nexpr.home."${username}".gui.fonts;

in {
  options = {
    nexpr.home."${username}".gui.fonts = {
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

      defaults = mkOption {
        description = "Default font names for each typeface family";
        type = attrsOf (listOf str);
        default = null;
        example = {
          serif = [
            "Ubuntu"
          ];
          sansSerif = [
            "Liberation"
            "Noto"
          ];
          monospace = [
            "Hack"
          ];
        };
      };
    };
  };

  config = mkIf cfg.enable {
    home-manager.users."${username}" = {
      home.packages =
          if (builtins.length cfg.nerd != 0)
          then cfg.ttf ++ [
            (pkgs.nerdfonts.override { fonts = cfg.nerd; })
          ]

          else cfg.ttf;

      fonts = {
        fontconfig = mkIf (cfg.defaults != null) {
          enable = true;
          defaultFonts = cfg.defaults;
        };
      };
    };
  };
}
