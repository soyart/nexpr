username:

{ ... }:

{
  imports = [
    (import ../../home/modules/gui/progs/sway.nix username)
  ];

  nexpr.per-user."${username}".gui.progs.sway.enable = true;
}
