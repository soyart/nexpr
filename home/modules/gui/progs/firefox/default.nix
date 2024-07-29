username:

{ lib, config, pkgs, ... }:

with lib;
with lib.types;

let
  perUser = config.nexpr.home."${username}";
  cfg = perUser.gui.progs.firefox;
  cfgSway = perUser.gui.progs.sway;

in {
  options = {
    nexpr.home."${username}".gui.progs.firefox = {
      enable = mkEnableOption "Enable Firefox (Wayland-only)";
      withPipewire = mkOption {
        description = "Enable Pipewire support in Firefox (i.e. for screen sharing and web conferences)";
        type = bool;
        default = false;
      };
    };
  };

  config = mkIf cfg.enable {
    services.pipewire.enable = cfg.withPipewire;

    home-manager.users."${username}" = {
      home.sessionVariables = {
        BROWSER = "firefox";
        MOZ_ENABLE_WAYLAND = "1";
        XDG_CURRENT_DESKTOP = mkIf cfgSway.enable "sway";
      };

      xdg.portal = {
        enable = true;
        extraPortals = [
          pkgs.xdg-desktop-portal-wlr
        ];

        # Any back-end found first in lexical order
        config.common.default = "*";
      };

      programs.firefox = {
        enable = true;
        package = if cfg.withPipewire
          then (pkgs.wrapFirefox (
            pkgs.firefox-unwrapped.override {
              pipewireSupport = true;
            }) {}
          )

          else pkgs.firefox;
      };
    };
  };
}
