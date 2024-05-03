{ lib, config, pkgs, username, unix, ... }:

with lib;

let
  cfg = config.nexpr.gui.sway;

in {
  options = {
    nexpr.gui.sway = {
      enable = mkEnableOption "Enable Sway DM with config from packages/drvs/unix";
    };
  };

  config = mkIf cfg.enable {
    security.polkit.enable = true;

    users.users."${username}" = {
      extraGroups = [ "audio"  "video" ];
    };

    sound.enable = true;

    hardware = {
      pulseaudio.enable = true;
      opengl.enable = true;
    };

    home-manager.users."${username}" = {
      home.packages = with pkgs; [
        alacritty # Default terminal in sway config from unix
        wl-clipboard
        brightnessctl
        pulseaudio
        dash
        swayidle
        lm_sensors
      ];

      home.sessionVariables = {
        WAYLAND = "1";
        MOZ_ENABLE_WAYLAND = "1";
        XDG_SESSION_TYPE = "wayland";
        XDG_CURRENT_DESKTOP = "sway";
      };

      home.file = {
        ".config/sway" = {
          source = "${unix}/dotfiles/linux/.config/sway";
          recursive = true;
        };

        ".config/dwm" = {
          source = "${unix}/dotfiles/linux/.config/dwm";
          recursive = true;
        };

        ".config/alacritty" = {
          source = "${unix}/dotfiles/pkg/alacritty/.config/alacritty";
          recursive = true;
        };

        "bin" = {
          source = "${unix}/sh-tools/bin";
          recursive = true;
        };

        "wall" = {
          source = ./wall;
          recursive = true;
        };
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
