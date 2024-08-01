username:

{ ... }:

{
  imports = [
    (import ../../modules/home/gui/progs/firefox username)
  ];

  nexpr.home."${username}".gui.progs.firefox = {
    enable = true;
    withPipewire = true;
  };
}
