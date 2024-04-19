{ lib }:

with lib;
with lib.lists;

let
  regexV4 = "(([0-9]+).([0-9]+).([0-9]+).([0-9]+))";
  regexV4WithPort = regexV4 + "\:([0-9]+)";

in
rec {
  inherit regexV4 regexV4WithPort;

  assertV4 = addr: let
      matched = builtins.match regexV4 addr;
      s = lists.elemAt matched 0;
      componentsInts = map strings.toInt (builtins.tail matched);

    in
    s == addr
      && builtins.length componentsInts == 4
      && builtins.all (x: x < 255) componentsInts;

  assertV4WithPort = addr: let
      matched = builtins.match regexV4WithPort addr;
      address = lists.elemAt matched 0;
      componentsInts = map strings.toInt (builtins.tail matched);
      componentsAddr = lists.take 4 componentsInts;
      port = lists.last componentsInts;

    in
    {
      inherit address port;

      valid = builtins.length componentsAddr == 4
        && (port' <= 65535)
        && (builtins.all (x: x < 255) componentsAddr);
    };
}
