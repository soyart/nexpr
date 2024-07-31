username:

{ pkgs, ... }:

{
  imports = [
    (import ../../modules/home/gui/fonts.nix username)
  ];

  nexpr.home."${username}".gui.fonts = {
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
}
