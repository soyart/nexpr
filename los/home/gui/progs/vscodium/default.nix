username:

{ lib, pkgs, config, ... }:

let
  types = lib.types;
  cfg = config.los.home."${username}".progs.vscodium;

in {
  options = {
    los.home."${username}".progs.vscodium = {
      enable = lib.mkEnableOption "Enable VSCodium module";
      extensions = lib.mkOption {
        type = types.listOf types.package;

        example = with pkgs.vscode-extensions; [
          golang.go
          jnoortheen.nix-ide
          rust-lang.rust-analyzer
        ];

        # https://search.nixos.org/packages?channel=24.05&from=0&size=50&sort=relevance&type=packages&query=vscode-extensions
        default = with pkgs.vscode-extensions; [
          golang.go
          jnoortheen.nix-ide
          rust-lang.rust-analyzer
        ];
      };
    };   
  };

  config = lib.mkIf cfg.enable {
    home-manager.users."${username}" = {
      programs.vscode = {
        enable = true;
        # package = pkgs.vscodium;
        package = pkgs.vscodium.fhs; # With normal FHS-style chroot
        extensions = cfg.extensions;
      };
    };
  };
}
