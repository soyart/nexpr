username:

{ ... }:

{
  imports = [
    (import ../../modules/home/progs/helix username)
  ];

  nexpr.home."${username}".progs.helix.enable = true;
}
