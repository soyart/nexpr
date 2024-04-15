{ size ? null }:

let
  mntOpts = ["defaults" "mode=755"];

in
{
  device = "none";
  fsType = "tmpfs";
  options = if size == null then mntOpts else mntOpts ++ ["size=${size}"];
}
