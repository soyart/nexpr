username:

{ pkgs, ... }:

{
  imports = [
    ../../home/modules/gui/fonts.nix
  ];

  nexpr.gui.fonts = {
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
