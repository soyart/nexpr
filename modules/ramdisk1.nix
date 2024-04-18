{ lib, config, ... }:

with lib;
with lib.types;

{
  options.ramDisks = mkOption {
    type = attrsOf (submodule {
      options = {
        perm = mkOption { type = str; default = "755"; };
        size = mkOption { type = nullOr str; default = null; };
        neededForBoot = mkOption {type = bool; default = true;};
      };
    });
  };

  config = let
    cfg = config.ramDisks;

    mapFn = key: value: let
      mntOpts = ["defaults" "mode=${value.perm}"];
    in
    {
      device = "none";
      fsType = "tmpfs";
      options = if value.size == null then mntOpts else mntOpts ++ ["size=${value.size}"];
    };

    in {
      # Nix module system will merge this to global config.fileSystems
      fileSystems = mapAttrs mapFn cfg;
    };
}
