{ lib, config, ... }:

with lib;
with lib.types;

let
  cfg = config.nexpr.net.unboundDoT;

in {
  options.nexpr.net.unboundDoT = {
    enable = mkEnableOption "Enable DNS-over-TLS with unbound";
    nameserversDoT= mkOption {
      type = listOf str // {
        check = (li: builtins.length li != 0);
      };
      example = ["1.1.1.1@853#one.one.one.one" "9.9.9.9@853#dns.quad9.net"];
      default = ["1.1.1.1@853#one.one.one.one" "9.9.9.9@853#dns.quad9.net"];
      description = "";
    };
  };

  config = mkIf cfg.enable {
    services.unbound = {
      enable = true;
      enableRootTrustAnchor = true;

      # settings are mapped verbatim to unbound.conf(5)
      settings = {
        remote-control.control-enable = true;
        server = {
          val-log-level = 2;
          aggressive-nsec = true;
          hide-identity = true;
          hide-version = true;
          interface = [
            "127.0.0.1"
          ];
          access-control = [
            "127.0.0.0/8 allow"
            "0.0.0.0/0 refuse"
            "::0/0 refuse"
            "::1 allow"
          ];
        };

        forward-zone = [
          {
            name = ".";
            forward-tls-upstream = true;
            forward-first = false;
            forward-addr = cfg.nameserversDoT;
          }
        ];
      };
    };
  };
}
