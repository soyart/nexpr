username:

{ ... }:

{
  imports = [
    (import ../../home/modules/gui/progs/firefox username)
  ];

  nexpr.per-user."${username}".gui.progs.firefox = {
    enable = true;
    withPipewire = true;
  };
}
