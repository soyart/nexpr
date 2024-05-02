{ inputs, username, unix, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager

    ../../modules/gui/sway.nix
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };

    users = {
      "${username}" = {
          home.file = {
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
