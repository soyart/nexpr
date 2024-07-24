{ lib, config, pkgs, username, inputs, ... }:

with lib;

let
  cfg = config.nexpr.gui.progs.sway;
  unix = inputs.unix;

in {
  imports = [
    ../sound.nix    
  ];

  options = {
    nexpr.gui.progs.sway = {
      enable = mkEnableOption "Enable Sway DM with config from gitlab.com/artnoi/unix";
    };
  };

  config = mkIf cfg.enable {
    security = {
      polkit.enable = true;
      pam.services.swaylock = {};
    };

    users.users."${username}" = {
      extraGroups = [ "audio"  "video" ];
    };

    hardware = {
      graphics.enable = true;
    };

    home-manager.users."${username}" = {
      home.packages = with pkgs; [
        swayidle
        swaylock
        alacritty # Default terminal in sway config from unix
        wl-clipboard
        brightnessctl
        dash
        lm_sensors
        wofi
        dmenu

        (writeShellScriptBin "sndctl" ''
          ${builtins.readFile "${unix}/sh-tools/bin/sndctl-wireplumber"}
        '')
      ];

      home.sessionVariables = {
        WAYLAND = "1";
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

        ".config/wofi" = {
          source = "${unix}/dotfiles/linux/.config/wofi";
          recursive = true;
        };

        "bin" = {
          source = "${unix}/sh-tools/bin";
          recursive = true;
        };

        # @TODO: separate module
        ".config/alacritty" = {
          source = "${unix}/dotfiles/pkg/alacritty/.config/alacritty";
          recursive = true;
        };

        "wall" = {
          source = ../wall;
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
