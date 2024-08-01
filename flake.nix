{
  description = "NixOS configuration";

  outputs = { ... }@inputs: {
    homeConfigurations = import ./modules/home { inherit inputs; };
    nixosConfigurations = import ./modules/nixos { inherit inputs; };
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";

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

  nixConfig = {};
}
