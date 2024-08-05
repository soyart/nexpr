username:

{ lib, pkgs, config, hostname, ... }:

with lib;
with lib.types;

let
  cfg = config.los.home."${username}".progs.git;

in {
  options = {
    los.home."${username}".progs.git = {
      enable = mkEnableOption "Enable los Git";

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

      editor = mkOption {
        type = submodule {
          options.package = mkOption {
            description = "Nix package to for git $EDITOR program";
            type = package;
            default = pkgs.helix;
          };

          options.binPath = mkOption {
            description = "Path to executable from the derivation root of package";
            type = str // {
              check = (s: (builtins.stringLength s) != 0);
            };
            default = "bin/hx";
          };
        };
      };
    };
  };

  config = (mkIf cfg.enable) {
    home-manager.users."${username}" =
      let editor = cfg.editor;

    in {
      home.sessionVariables = {
        EDITOR = "${editor.package.outPath}/${editor.binPath}"; 
      };

      programs = {
        ${editor.package.pname}.enable = true;        

        git = {
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
  };
}
