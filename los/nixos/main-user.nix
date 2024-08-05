{ lib, config, ... }:

with lib;
with lib.types;

let
  cfg = config.los.mainUser;

in {
  options.los.mainUser = {
    enable = mkEnableOption "Enable mainUser module";

    username= mkOption {
      description = "Username";
      type = str // {
        check = (s: s != "root");
      };
      default = "los";
      example = "bob";
    };

    groups = mkOption {
      description = "Extra groups other than 'weel' and `users`";
      type = listOf str // {
        check =  (li: !(builtins.elem "wheel" li));
      };
      default = [];
      example = [ "video" "docker" ];
    };
  };

  config = mkIf cfg.enable {
    users.groups."${cfg.username}" = {
      members = [ cfg.username];
    };

    users.users.${cfg.username} = {
      isNormalUser = true;
      home = "/home/${cfg.username}";
      createHome = true;
      extraGroups = cfg.groups ++ [ "wheel" ];
    };
  };
}
