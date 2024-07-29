username:

{ ... }:

{
  imports = [
    (import ../../home/modules/langs username)
  ];

  nexpr.home."${username}".langs = {
    go.enable = true;
    rust.enable = true;
  };
}
