{ inputs, pkgs, username, unix, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager

    ../../modules/gui/sway.nix
    ../../modules/gui/fonts.nix
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
      # nerdFonts = [
      #   "Hack"
      # ];
      # familyDefaults = {
      #   sansSerif = "Liberation";
      #   monospace = "Hack";
      # };
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };

    users = {
      "${username}" = {
          home.file = {
            ".config/helix" = {
              source = "${unix}/dotfiles/pkg/helix/.config/helix";
              recursive = true;
            };
          };

          home.stateVersion = "24.05";
      };
    };
  };
}
