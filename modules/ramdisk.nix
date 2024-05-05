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
        owner = mkOption { type = str; default = "root"; };
        group = mkOption { type = str; default = "root"; };
        size = mkOption { type = nullOr str; default = null; };
      };
    });
    example = {
      "/rd1" = {};
      "/rd2".size = "500M";
      "/rd2".group = "wheel";
      "/rd3" = {
        size = "1G";
        perm = "744";
      };
    };
  };

  config = let
    mapFn = key: value: let
      mntOpts = ["defaults" "mode=${value.perm}"]
        ++ lib.optional (value.size != null) "size=${value.size}"
        ++ lib.optional (value.owner != null) "uid=${value.owner}"
        ++ lib.optional (value.group != null) "gid=${value.group}";

    in {
      device = "none";
      fsType = "tmpfs";
      options = mntOpts;
    };

  in {
    # Nix module system will merge this to global config.fileSystems
    fileSystems = mapAttrs mapFn cfg;
  };
}
