{ lib, config, ... }:

with lib;
with lib.types;

{
  options.ramDisks = mkOption {
    type = listOf (submodule {
      options = {
        mnt = mkOption { type = str; };
        perm = mkOption { type = str; default = "755"; };
        size = mkOption { type = nullOr str; };
      };
    });
  };

  config = let
    cfg = config.ramDisks;

    mapFn = c: {
      "${c.mnt}" = {
        device = "none";
        fsType = "tmpfs";
        options = let
          mntOpts = [ "defaults"  "mode=${c.perm}" ];
        in
        mntOpts;
      };
    };
    
    in {
      fileSystems = attrsets.mergeAttrsList (builtins.map mapFn cfg);
    };
}
