username:

{ ... }:

{
  imports = [
    (import ../../home/modules/progs/helix username)
  ];

  nexpr.home."${username}".progs.helix.enable = true;
}
