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
        owner = mkOption { type = str; default = "root"; };
        group = mkOption { type = str; default = "root"; };
        size = mkOption { type = nullOr str; default = null; };
      };
    });
    example = [
      { mnt = "/rd1"; }
      { mnt = "/rd2"; size = "1G"; perm = 744; }
      { mnt = "/rd3"; size = "500M"; group = "root"; }
    ];
  };

  config = let
    mapFn = c: {
      "${c.mnt}" = {
        device = "none";
        fsType = "tmpfs";
        options = [
          "defaults"
          "mode=${value.perm}"
          "uid=${value.owner}"
          "gid=${value.group}"
        ]
        ++ lib.optional (value.size != null) "size=${value.size}";
      };
    };
    
    in {
      fileSystems = attrsets.mergeAttrsList (map mapFn cfg);
    };
}
