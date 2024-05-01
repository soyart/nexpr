{ inputs, config, pkgs, ... }:

let
  unix = pkgs.callPackage ../../packages/drvs/unix  {};

in {
  imports = [
    inputs.home-manager.nixosModules.default
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  # home-manager.users."${config.nexpr.mainUser.username}" = {
  #   home.files.".config/helix" = {
  #     source = "${unix}/dotfiles/pkg/helix/.config/helix";
  #     recursive = true;
  #   };
  # };
}
