username:

{ ... }:

{
  imports = [
    (import ../../los/home/progs/helix username)
  ];

  los.home."${username}".progs.helix.enable = true;
}
