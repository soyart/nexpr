
{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }: with nixpkgs.lib; {
    nixosConfigurations."nexpr-t14" = nixosSystem {
      system = "x86_64-linux";
      modules = [ ../../hosts/t14/configuration.nix ];
    };
  };
}
