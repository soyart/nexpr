{ ... }:

{
  imports = [
    ../../home/modules/gui/progs/firefox
  ];

  nexpr.gui.progs.firefox = {
    enable = true;
    withPipewire = true;
  };
}
