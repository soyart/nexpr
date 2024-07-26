username:

{ pkgs, ... }:

{
  imports = [
    (import ../../home/modules/progs/git username)
  ];

  nexpr.progs.git = {
    enable = true;
    withLfs = false;
    username = "soyart";  
    email = "artdrawin@gmail.com";

    editor = {
      package = pkgs.helix;
      binPath = "bin/hx";
    };
  };
}
