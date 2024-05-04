{ pkgs, username, ... }:

{
  services.pipewire.enable = true;

  home-manager.users."${username}" = {
    home.sessionVariables = {
      BROWSER = "firefox";
      MOZ_ENABLE_WAYLAND = "1";
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
      package = (pkgs.wrapFirefox (pkgs.firefox-unwrapped.override { pipewireSupport = true; }) {});
    };
  };
}
