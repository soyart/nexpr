{ config, pkgs, ... }:

let
  unix = pkgs.callPackage ../../packages/drvs/unix  {};

in {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users."${config.nexpr.mainUser.username}" = {
    home.file.".config/helix" = {
      source = "${unix}/dotfiles/pkg/helix/.config/helix";
      recursive = true;
    };

    home.stateVersion = "24.05";
  };
}
