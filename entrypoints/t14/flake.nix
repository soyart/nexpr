
{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs : with nixpkgs.lib; {
    nixosConfigurations."nexpr-t14" = nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit home-manager inputs; };
      modules = [
        ./default.nix

        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.artnoi = {
            # home.file.".config/helix" = {
            #   source = "${unix}/dotfiles/pkg/helix/.config/helix";
            #   recursive = true;
            # };

            home.stateVersion = "24.05";
          };
        }
      ];
    };
  };
}
