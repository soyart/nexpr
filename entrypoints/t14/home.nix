{ inputs, pkgs, username, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager

    ../../modules/gui/sway.nix
    ../../modules/gui/fonts.nix

    ../../modules/progs/helix
  ];

  nexpr.gui = {
    sway.enable = true;

    fonts = {
      enable = true;

      ttf = with pkgs; [
        hack-font
        inconsolata
        liberation_ttf
      ];

      nerd = [ "Hack" ];

      defaults = {
        sansSerif = [ "Liberation" ];
        monospace = [ "Hack" ];
      };
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };

    users = {
      "${username}" = {
          home.stateVersion = "24.05";
      };
    };
  };
}
