username:

{ ... }:

{
  imports = [
    (import ../../los/home/langs username)
  ];

  los.home."${username}".langs = {
    go.enable = true;
    rust.enable = true;
  };
}
