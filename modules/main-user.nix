{ lib, config, ... }:

with lib;
with lib.types;

let
  cfg = config.mainUser;

in
{
  options = {
    mainUser = {
      enable = mkEnableOption "Enable mainUser module";

      userName = mkOption {
        description = "Username";
        type = str // {
          check = (s: s != "root");
        };
        default = "nixuser";
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
  };

  config = mkIf cfg.enable {
    users.groups."${cfg.userName}" = {
      members = [ cfg.userName ];
    };

    users.users.${cfg.userName} = {
      isNormalUser = true;
      home = "/home/${cfg.userName}";
      createHome = true;
      extraGroups = cfg.groups ++ [ "wheel" ];
    };
  };
}
