{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs,  ... }@inputs : with nixpkgs.lib;
    let
      hostname = "nexpr-t14";
      username = "artnoi";

    in {
      nixosConfigurations."${hostname}" = nixosSystem rec {
        system = "x86_64-linux";
        modules = [
          ./default.nix
        ];

        specialArgs =
          let
            pkgs = import nixpkgs { inherit system; };
            unix = pkgs.callPackage ../../packages/drvs/unix/drv.nix {};

          in {
            inherit
              inputs
              hostname
              username
              unix;
          };
      };
  };
}
