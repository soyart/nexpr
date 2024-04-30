
{
  description = "Flake for NixOS 23.11";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
  };

  outputs = { self, nixpkgs, ... }: with nixpkgs.lib; {
    nixosConfigurations."nexpr-t14" = nixosSystem {
      system = "x86_64-linux";
      modules = [ ../../hosts/t14/configuration.nix ];
    };
  };
}
