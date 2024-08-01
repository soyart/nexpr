username:

{ ... }:

{
  imports = [
    (import ../../modules/home/langs username)
  ];

  nexpr.home."${username}".langs = {
    go.enable = true;
    rust.enable = true;
  };
}
