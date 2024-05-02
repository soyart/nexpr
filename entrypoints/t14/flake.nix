{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs,  ... }@inputs :
    with nixpkgs.lib;
    let
      hostname = "nexpr-t14";
      username = "artnoi";

    in {
      nixosConfigurations."${hostname}" = nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs hostname username; };

        modules = [
          ./default.nix
        ];
      };
    };
}
