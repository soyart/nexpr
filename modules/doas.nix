{ lib, config, pkgs, ... }:

{
  options = {
    doas.enable = lib.mkEnableOption "enable doas"

    doas.keepSudo = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    doas.keepEnv = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    doas.persist = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };

    doas.users = lib.mkOption {
      type = lib.types.listOf lib.types.str;
    };
    doas.groups = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
    };
  };

  config = lib.mkIf config.doas.enable {
    security.sudo.enable = config.doas.keepSudo;
    security.doas.enable = true;
    security.doas.extraRules = [{
      users = config.doas.users;
      groups = config.doas.groups;
      keepEnv = config.doas.keepEnv;
      persist = config.doas.persist;
    }];
  };
}
