username:

{ ... }:

{
  imports = [
    (import ../../home/modules/gui/progs/firefox username)
  ];

  nexpr.home."${username}".gui.progs.firefox = {
    enable = true;
    withPipewire = true;
  };
}
