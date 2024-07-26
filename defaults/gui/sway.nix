username:

{ ... }:

{
  imports = [
    (import ../../home/modules/gui/progs/sway.nix username)
  ];

  nexpr.gui.progs.sway.enable = true;
}
