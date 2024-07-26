# nexpr

Nix expressions and NixOS configurations

## Structure

Nexpr is organized into directories, namely

- [nixos](./nixos/) and [home](./home/)

  NixOS configuration modules (top-level is `nexpr`).
  The top-level directory is not a rule, but more like a guideline:
  all modules under [`nixos`](./nixos/) should not touch home-manager
  or use any values from [`home`](./home/) modules, although home
  modules might set system configurations.

- [opinionated library](./libnexpr/)

  Simple (sometimes useless) non-module Nix code, usually functions.

- [package lists](./packages/) in text files

  List of package names to be imported by [syspkgs module](./nixos/modules/syspkgs.nix).

- [defaults](./defaults/)

  Default, ready-to-go configuration modules for some high-level concepts or programs.
  They provide no configurable options, and consumers are only expected to simply import
  the defaults.

- [presets](./presets/)

  High-level ready-to-go configuration modules. This is what we'd probably write to
  extend `configuration.nix` and `hardware-configuration.nix`, i.e. our config.

  Presets usually cover everything but the boot process or hardware settings.
  Lower-level, machine-specific configuration like the boot process, mountpoints,
  and kernel settings should be defined in `hosts/<host>`.

  Like with defaults, they provide no options.
