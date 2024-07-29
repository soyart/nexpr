username:

{ lib, config, pkgs, ... }:

with lib;
with lib.types;

let
  cfg = config.nexpr.home."${username}".progs.helix;

in {
  options = {
    nexpr.home."${username}".progs.helix = {
      enable = mkEnableOption "Enable Helix editor from Nexpr";
      langServers = mkOption {
        description = "List of LSP Nix packages only available to Helix";
        type = listOf package;
        default = with pkgs; [
          nil
        ];
        example = with pkgs; [
          nil
          gopls
          marksman
        ];
      };
    };
  };

  config = mkIf cfg.enable {
    home-manager.users."${username}" = {
      programs.helix = {
        enable = true;

        extraPackages = mkIf ((builtins.length cfg.langServers) != 0)
          cfg.langServers;

        settings = {
          theme = "catppuccin_macchiato";
          editor = import ./editor.nix;
          keys = import ./keys.nix;
        };

        languages = import ./languages.nix { inherit pkgs; };
      };
    };
  };
}
