{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    unix = {
      type = "gitlab";
      owner = "artnoi";
      repo = "unix";
      ref = "tmp/sndctl";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, unix, ... }@inputs : with nixpkgs.lib;
    let
      hostname = "nexpr-t14";
      username = "artnoi";

    in {
      nixosConfigurations."${hostname}" = nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./default.nix
        ];

        specialArgs = {
          inherit
            inputs
            hostname
            username
            unix;
        };
      };
  };
}
