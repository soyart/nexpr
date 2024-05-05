# nexpr

Nix expressions and NixOS configurations

## Structure

> Note: we can symlink nexpr with [stow to nexpr root](#nexpr-location)
> (`$HOME/.nexpr`) with a non-Nixed Bash script [`stow.sh`](./stow.sh)

Nexpr is organized into directories, namely
(1) entrypoints, (2) hosts files, (3) reusable modules,
(4) library, and (5) packages.

### 1. Entrypoints

Top-level Nix and NixOS expressions.

The convention is that each entrypoint is machine-specific,
replacing vanilla system's `configuration.nix`.

#### What's in the entrypoints?

If Nix Flakes are used, they are rooted here (i.e. entrypoints should
contain `flake.nix` and `flake.lock`) An *pure* entrypoint can be as simple as
a collection of 3 files - 2 files for Nix flakes plus one (the Nix expression).

For complex setup such as a desktop environment, files are broken
into roughly 3 parts - a `default.nix` for system configuration,
a `home.nix` for user home management, and `hardware.nix` for enabling more
complete hardware support.

### 2. Host files

Hosts are machine-specific NixOS expressions
and are placed here under [`hosts`](./hosts/) with
arbitrary directory names such as [hosts/t14](./hosts/t14/)

A single complete system should only correspond to *a single* host directory

2 files per host is our goal here (like in vanilla NixOS) -
a `configuration.nix` and a generated `hardware-configuration.nix`

A host's expressions are [symlinked to `/etc/nixos`](#nexpr-location)

### 3. Nexpr modules

Nexpr modules are general, shared nexpr Nix modules. Entrypoints generally
import the modules to compose higher-level Nix expressions

These modules are rooted in `./modules` with Nix module option `nexpr`,
i.e. `./modules/foo.nix` is `options.nexpr.foo`, and `./modules/foo/bar`
is `options.nexpr.foo.bar`.

### 4. Nexpr library `libnexpr`

The library provides helper functions or expressions. Unlike `modules`,
libnexpr files are not neccessarily Nix modules

### 5. Non-Nix

Nexpr also provides non-Nix files,
e.g. directory [`./packages`](./packages) which holds plaintext files,
each is a list of package names in plain text, one package per line.
