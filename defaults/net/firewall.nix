{ ... }:

{
  imports = [
    ../../nixos/modules/net/firewall.nix
  ];

  nexpr.net.firewall = {
    enable = true;
    global = {
      allowPing = false;
    };
  };
}
