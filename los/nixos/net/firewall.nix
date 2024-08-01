{ lib, config, ... }:

with lib;
with lib.types;

let
  cfg = config.los.net.firewall;

  fw = {
    options = {
      allowPing = mkOption {
        description = "Allow ping when firewall is up";
        type = bool;
        default = false;
      };

      portsTcp = mkOption {
        description = "Open TCP ports";
        type = listOf int;
        default = [];
      };

      portsUdp = mkOption {
        description = "Open UDP ports";
        type = listOf int;
        default = [];
      };
    };
  };

in
{
  options.los.net.firewall = {
    enable = mkEnableOption "Enable los firewall";
    global = mkOption {
      description = "Global firewall for all network interfaces";
      type = submodule fw;
      default = {};
    };

    # interfaces = mkOption {
    #   description = "Maps names of interfaces to los firewall";
    #   type = attrsOf (submodule fw);
    #   default = {};
    # };
  };

  config = mkIf cfg.enable {
    networking.nftables.enable = true;
    networking.firewall = {
      enable = true;
      allowPing = cfg.global.allowPing;
      allowedUDPPorts = cfg.global.portsUdp;
      allowedTCPPorts = cfg.global.portsTcp;
    };
  };
}
