# nexpr

Nix expressions and NixOS configurations

## Structure

Nexpr is organized into directories, namely

- [nixos](./nixos/) and [home](./home/)

  NixOS configuration modules (top-level option is `nexpr`).

  > Module locations do not follow struct rules, but more like a guideline:
  >
  > All modules under [`nixos`](./nixos/) should not touch home-manager
  > or use any values from [`home`](./home/) modules, although home
  > modules might set system configurations (e.g. fonts and sound, which
  > are system-wide and are only configured if some *home* options are enabled),
  > or a user's Firefox feature option which might enable some system options.

  - [`./nixos`](./nixos/) -> `nexpr`

    The modules here provide `nexpr` system options like networking, mountpoints,
    and main user.

    Per-host configurations should be consolidated into a single module
    under [`./nixos/hosts`](./nixos/hosts/). Preferrably, these *hosts* modules should
    not declare any options (i.e. they are `imports`-only modules).

  - [`./home`](./home/) -> `nexpr.home.${username}` or `nexpr.home`

    The modules here provide `nexpr.home` user options like program configurations,
    user-specific packages, etc.

    Some options under `./home/` may provide `nexpr.gui`
    options (system-wide), like `nexpr.gui.sound` and `nexpr.gui.fonts`.
    This is because home-manager does not directly provide options for such configurations.

    ### User-specific options

    Options under `nexpr.home` are user-specific. The per-user configuration
    is implemented by simple, stupid functional module factories that takes
    in a username and returns a user-specific nexpr modules under `nexpr.home.${username}`.

    The options `nexpr.home.${username}` will then be mapped to `home-manager.users.${username}`.

    Note that `home-manager.sharedModules` is not used because some modules here might need to set
    system configurations too, usually low-level or security-related NixOS options.

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
