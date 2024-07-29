username:

{ ... }:

{
  imports = [
    (import ../../home/modules/gui/progs/sway username)
  ];

  nexpr.home."${username}".gui.progs.sway.enable = true;
}
