{ lib, config, ... }:

with lib;
with lib.types;

let
  cfg = config.nexpr.ramDisks;

in {
  options.nexpr.ramDisks = mkOption {
    description = "Set of tmpfs mounts";
    type = attrsOf (submodule {
      options = {
        perm = mkOption { type = str; default = "755"; };
        size = mkOption { type = nullOr str; default = null; };
      };
    });
    example = {
      "/rd1" = {};
      "/rd2".size = "500M";
      "/rd3" = {
        size = "1G";
        perm = "744";
      };
    };
  };

  config = let
    mapFn = key: value: let
      mntOpts = ["defaults" "mode=${value.perm}"];
    in {
      device = "none";
      fsType = "tmpfs";
      options = if value.size == null then mntOpts else mntOpts ++ ["size=${value.size}"];
    };

  in {
    # Nix module system will merge this to global config.fileSystems
    fileSystems = mapAttrs mapFn cfg;
  };
}
