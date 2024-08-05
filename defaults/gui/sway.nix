username:

{ ... }:

{
  imports = [
    (import ../../los/home/gui/progs/sway username)
  ];

  los.home."${username}".gui.progs.sway.enable = true;
}
