{ inputs, pkgs, username, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager

    ../../modules/progs/git
    ../../modules/progs/helix

    ../../modules/gui/sway.nix
    ../../modules/gui/fonts.nix
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };

    users = {
      "${username}" = {
          programs.bash = {
            enable = true;
            historyControl = [ "ignoredups" ];
            historyFileSize = 512;
          };

          home.stateVersion = "24.05";
      };
    };
  };

  nexpr = {
    progs = {
      git = {
        enable = true;
        username = "soyart";  
        email = "artdrawin@gmail.com";
      };
    };

    gui = {
      sway.enable = true;

      fonts = {
        enable = true;

        ttf = with pkgs; [
          hack-font
          inconsolata
          liberation_ttf
        ];

        nerd = [
          "Hack"
        ];

        defaults = {
          sansSerif = [
            "Liberation"
          ];

          monospace = [
            "Hack"
          ];
        };
      };
    };
  };
}
