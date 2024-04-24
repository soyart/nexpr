{ lib, config, ... }:

with lib;
with lib.types;

let
  cfg = config.nexpr.doas;

in {
  options.nexpr.doas = {
    enable = mkEnableOption "Enable doas";

    keepSudo = mkOption {
      type = bool;
      default = true;
      description = "Keep sudo on the system";
    };

    settings = {
      users = mkOption {
        type = listOf str;
        description = "List of usernames with doas enabled";
      };
      groups = mkOption {
        type = listOf str;
        default = [];
        description = "List of user groups with doas enabled";
      };
      keepEnv = mkOption {
        type = bool;
        default = true;
      };
      persist = mkOption {
        type = bool;
        default = true;
      };
    };
  };

  config = mkIf cfg.enable {
    security.sudo.enable = cfg.keepSudo;

    security.doas.enable = true;
    security.doas.extraRules = [{
      users = cfg.settings.users;
      groups = cfg.settings.groups;
      keepEnv = cfg.settings.keepEnv;
      persist = cfg.settings.persist;
    }];
  };
}
