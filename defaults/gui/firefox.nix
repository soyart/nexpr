username:

{ ... }:

{
  imports = [
    (import ../../home/modules/gui/progs/firefox username)
  ];

  nexpr.gui.progs.firefox = {
    enable = true;
    withPipewire = true;
  };
}
