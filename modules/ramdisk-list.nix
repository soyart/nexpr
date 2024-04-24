{ lib, config, ... }:

with lib;
with lib.types;

let
    cfg = config.nexpr.ramDiskList;

in {
  options.nexpr.ramDiskList = mkOption {
    description = "List of tmpfs mounts";
    type = listOf (submodule {
      options = {
        mnt = mkOption { type = str; };
        perm = mkOption { type = str; default = "755"; };
        size = mkOption { type = nullOr str; default = null; };
      };
    });
    example = [
      { mnt = "/rd1"; }
      { mnt = "/rd2"; size = "500M";}
      { mnt = "/rd2"; size = "1G"; perm = 744; }
    ];
  };

  config = let
    mapFn = c: {
      "${c.mnt}" = {
        device = "none";
        fsType = "tmpfs";
        options = let
          mntOpts = [ "defaults"  "mode=${c.perm}" ];
        in
        if c.size == null then mntOpts else mntOpts ++ ["size=${c.size}"];
      };
    };
    
    in {
      fileSystems = attrsets.mergeAttrsList (map mapFn cfg);
    };
}
