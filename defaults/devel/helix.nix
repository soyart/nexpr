username:

{ ... }:

{
  imports = [
    (import ../../home/modules/progs/helix username)
  ];

  nexpr.progs.helix.enable = true;
}
