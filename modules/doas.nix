{ lib, config, ... }:

{
  options = {
    doas.enable = lib.mkEnableOption "enable doas";

    doas.settings.keepSudo = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    doas.settings.keepEnv = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    doas.settings.persist = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };

    doas.settings.users = lib.mkOption {
      type = lib.types.listOf lib.types.str;
    };
    doas.settings.groups = lib.mkOption {
      type = lib.types.nullOr (lib.types.listOf lib.types.str);
      default = null;
    };
  };

  config = lib.mkIf config.doas.enable {
    security.sudo.enable = config.doas.settings.keepSudo;

    security.doas.enable = true;
    security.doas.extraRules = [{
      groups = let
        groups = config.doas.settings.groups;
      in
      if groups == null then [] else groups;

      users = config.doas.settings.users;
      keepEnv = config.doas.settings.keepEnv;
      persist = config.doas.settings.persist;
    }];
  };
}
