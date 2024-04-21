
{
  description = "Flake for NixOS 23.11";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
  };

  outputs = { self, nixpkgs, ... }: let
    lib = nixpkgs.lib;

    in {
    nixosConfigurations = {
      "nexpr-t14" = lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./configuration.nix ];
      };
    };
  };
}
