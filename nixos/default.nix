{ inputs, ... }:

let
  inherit (inputs.nixpkgs.lib) nixosSystem;
  # inherit (inputs.disko.nixosModules) disko;
  # inherit (inputs.sops-nix.nixosModules) sops;

  mkHost = {
    modules,
    mainUser,
    hostname ? "nexpr",
    stateVersion ? "23.11",
    system ? "x86_64-linux",
    # disk ? ./disks/thinkpad.nix,
  }: nixosSystem {
    inherit system modules;

    specialArgs = {
      inherit hostname mainUser inputs stateVersion ;
    };

    # modules = [ sops disko ./shared ] ++ modules; 
    # specialArgs = { inherit inputs disk stateVersion; };
  };
in {
  "nexpr-t14" = mkHost {
    hostname = "nexpr-t14";
    mainUser = "artnoi";

    modules = [
      ./hosts/t14

      # Use home-manager as NixOS modules
      ({ inputs, config, ... }: {
        imports = [
          inputs.home-manager.nixosModules.home-manager
        ];

        config.home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = { inherit inputs; };
        };
      })

      # WIP: inject username
      ({ config, ... }: {
        imports = [
          ../presets/sway-dev
        ];

        config._module.args = {
          username = "artnoi";
        };
      })
    ];
  };
}
