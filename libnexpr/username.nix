{ lib, purpose }:

with lib;
with lib.types;

mkOption {
  description = "username to enable ${purpose} for";
  type = str // {
    check = s: (builtins.stringLength s) != 0;
  };
}
