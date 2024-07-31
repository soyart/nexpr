# nexpr

Nix expressions and NixOS configurations

## Structure

- [Nexpr modules](./modules/)

  Modules in nexpr is put under 2 directories: [system module in `nixos`](./modules/nixos/)
  and [user home module in `home`](./modules/home/).

  There's only 1 rule for modules: **a system module must never touch user home modules**.

  > We allow home modules to read or even set values of system modules,
  > or even `nixosConfigurations` itself, *if* that's the natural way to implement the home module.

  - [System modules in `nixos`](./nixos/)
  
    The root of this module is the top-level `nexpr`

    The modules here provide nexpr system options like networking, mountpoints,
    and main user.

    ### Host configurations
    
    Per-host configurations should be consolidated into a single module
    under [`./modules/nixos/hosts`](./modules/nixos/hosts/).

    Preferrably, these *hosts* modules should not declare any options (i.e.
    they are `imports`-only modules), and they should not touch home modules.

    This is because *hosts* are bare-minimum builds that can boot and connect
    to the internet.

    The way I like it is to use host configuration as the base, and build up from
    there with modules and [presets](./presets/).

  - [`./home`](./home/) -> `nexpr.home.${username}` or `nexpr.home`

    The modules here provide `nexpr.home` user options like program configurations,
    user-specific packages, etc.

    ### User-specific options

    Options under `nexpr.home` are user-specific. The per-user configuration
    is implemented by simple, stupid functional module factories that takes
    in a username and returns a user-specific nexpr modules under `nexpr.home.${username}`.

    The options `nexpr.home.${username}` will then be mapped to `home-manager.users.${username}`.

    Note that `home-manager.sharedModules` is not used because some modules here might need to set
    system configurations too, usually low-level or security-related NixOS options.

- [Library](./libnexpr/) (very opinionated)

  Simple (sometimes useless) non-module Nix code, usually functions.

- [Package lists](./packages/)

  List of package names to be imported by [syspkgs module](./modules/nixos/syspkgs.nix).

  Each text line is treated as pname of a Nix package.

- [Default settings](./defaults/)

  Ready-to-go, import-only modules with no options defined.

- [Presets and profiles](./presets/)

  Like defaults, but more complex. An example is [`sway-dev`](./presets/sway-dev/),
  which provides my working environment using Sway and Helix.

  Presets usually cover everything but the boot process or hardware settings.

  Lower-level, machine-specific configuration like the boot process, mountpoints,
  and kernel settings should be defined in `hosts/<host>/default.nix`.

  Like with defaults, they provide no options.
