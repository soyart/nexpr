{ pkgs, ... }:

{
  imports = [
    ../../home/modules/progs/git
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
