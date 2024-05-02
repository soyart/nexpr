{ lib, pkgs, username, unix, ... }:

with lib;

{
  options = {
    nexpr.sway = mkEnableOption "Enable sway with config from gitlab.com/artnoi/unix";
  };

  config = {
    security.polkit.enable = true;

    users.users."${username}" = {
      extraGroups = [ "video" ];
    };

    home-manager.users."${username}" = {
      home.packages = with pkgs; [
        wl-clipboard
        brightnessctl
        alacritty # Default terminal in sway config from unix
      ];

      home.file = {
        ".config/sway" = {
          source = "${unix}/dotfiles/linux/.config/sway";
          recursive = true;
        };

        ".config/dwm" = {
          source = "${unix}/dotfiles/linux/.config/sway";
          recursive = true;
        };
      };

      home.sessionVariables = {
        MOZ_ENABLE_WAYLAND = "1";
        XDG_SESSION_TYPE = "wayland";
        XDG_CURRENT_DESKTOP = "sway";
      };

      wayland.windowManager.sway = {
        enable = true;
        extraConfig = ''
           include ${unix}/dotfiles/linux/.config/sway/config
        '';
      };
    };
  };
}
