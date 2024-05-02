{ inputs, pkgs, username, ...}:

let
  unix = pkgs.callPackage ../../packages/drvs/unix/drv.nix {};

in {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    extraSpecialArgs = { inherit inputs; };
    users = {
      "${username}" = {
          home.file = {
            ".config/shell" = {
              source = "${unix}/dotfiles/pkg/shell/.config/shell";
              recursive = true;
            };

            ".bash_profile" = {
              source = "${unix}/dotfiles/pkg/shell/.bash_profile";
            };

            ".bashrc" = {
              source = "${unix}/dotfiles/pkg/shell/.bashrc";
            };

            ".os" = {
              source = "${unix}/dotfiles/pkg/shell/.os";
            };

            ".config/helix" = {
              source = "${unix}/dotfiles/pkg/helix/.config/helix";
              recursive = true;
            };
          };

          home.stateVersion = "24.05";
      };
    };
  };
}
