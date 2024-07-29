username:

{ ... }:

{
  imports = [
    (import ../../home/modules/langs username)
  ];

  nexpr.per-user."${username}".langs = {
    go.enable = true;
    rust.enable = true;
  };
}
