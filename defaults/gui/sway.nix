username:

{ ... }:

{
  imports = [
    (import ../../modules/home/gui/progs/sway username)
  ];

  nexpr.home."${username}".gui.progs.sway.enable = true;
}
