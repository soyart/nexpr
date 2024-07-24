{ inputs, pkgs, username, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager

    ../../../modules/gui
    ../../../modules/progs
    ../../../modules/langs
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

      helix = {
        enable = true;  
      };
    };

    gui = {
      progs = {
        sway.enable = true;
        firefox = {
          enable = true;
          withPipewire = true;
        };
      };

      fonts = {
        enable = true;

        ttf = with pkgs; [
          hack-font
          inconsolata
          liberation_ttf

          tlwg # Thai font
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

    langs = {
      go.enable = true;
      rust.enable = true;
    };
  };
}
