{ lib, config, username, hostname, ... }:

with lib;
with lib.types;

let
  cfg = config.nexpr.progs.git;

in {
  options = {
    nexpr.progs.git = {
      enable = mkEnableOption "Enable nexpr Git";
      withLfs = mkOption {
        description = "Enable Git LFS support";
        type = bool;
        default = false;
      };

      username = mkOption {
        description = "Git username";
        type = str;
        default = username;
      };

      email = mkOption {
        description = "Git email";
        type = str;
        default = "${username}@${hostname}";
      };
    };
  };

  config = mkIf cfg.enable {
    home-manager.users."${username}" = {
      programs.git = {
        enable = true;
        lfs.enable = cfg.withLfs;

        userName = cfg.username;
        userEmail = cfg.email;

        extraConfig = {
          push = {
            autoSetupRemote = true;  
          };
        };
      };
    };
  };
}
