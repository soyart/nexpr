username:

{ ... }:

{
  imports = [
    (import ../../home/modules/gui/progs/sway.nix username)
  ];

  nexpr.home."${username}".gui.progs.sway.enable = true;
}
