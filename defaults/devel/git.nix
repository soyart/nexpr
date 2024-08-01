username:

{ pkgs, ... }:

{
  imports = [
    (import ../../modules/home/progs/git username)
  ];

  nexpr.home."${username}".progs.git = {
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
