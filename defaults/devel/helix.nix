username:

{ ... }:

{
  imports = [
    (import ../../home/modules/progs/helix username)
  ];

  nexpr.per-user."${username}".progs.helix.enable = true;
}
