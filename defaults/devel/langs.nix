username:

{ ... }:

{
  imports = [
    (import ../../home/modules/langs username)
  ];

  nexpr.langs = {
    go.enable = true;
    rust.enable = true;
  };
}
