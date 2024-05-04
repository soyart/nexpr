# nexpr

Nix expressions and NixOS configurations

## Structure

Nexpr files are grouped into 3 categories:

### 1. Nexpr files

These files represent nexpr, and will be [stowed to nexpr root](#nexpr-location)
(`$HOME/.nexpr`) with a normal Bash script [`stow.sh`](./stow.sh)

There are 3 types of nexpr files, grouped together within the same
directories:

- Entrypoints `entrypoints`

  Top-level Nix and NixOS expressions.
  The convention is that each entrypoint is machine-specific,
  replacing vanilla system's `configuration.nix`.

  > If Nix Flakes are used, entrypoints should
  > contain `flake.nix` and `flake.lock`.

- [Nexpr modules `modules`](#nexpr-modules)

  Modules are general, shared nexpr Nix modules. Entrypoints generally
  import the modules to compose higher-level Nix expressions

- Nexpr library `libnexpr`

  The library provides helper functions or expressions.
  Unlike `modules`, libnexpr files are not neccessarily
  Nix modules

### 2. Host files

- Hosts are machine-specific NixOS expressions
  and are placed here under [`hosts`](./hosts/) with
  arbitrary directory names such as [hosts/t14](./hosts/t14/)

- Each machine should only correspond to *a single* host directory

- 2 files per host is our goal here (like in vanilla NixOS) -
  a `configuration.nix` and a generated `hardware-configuration.nix`

- A host's expressions are [symlinked to `/etc/nixos`](#nexpr-location)

### 3. Non-Nix

Nexpr also provides non-Nix files,
e.g. directory [`./packages`](./packages) which holds plaintext files,
each is a list of package names in plain text, one package per line.

## Nexpr modules

Nexpr modules are placed in [`./modules`](./modules).

### Top-level modules
 
Top-level modules (e.g. `./modules/doas.nix`) are ones that declare
their own options under `options.nexpr`.

They all are system configuration modules.

### Group modules

Group modules are grouped together by their common category,
e.g. `./modules/net` which defines network configuration,
or `./modules/gui` which defines GUI environment.

Unlike top-level modules, these modules may contain not only
system configuration, but also Home Manager configuration.
Some may even touch both.

There are 2 flavors of these - single-file modules
(e.g. `./modules/progs/git`) and directory modules
(e.g. `./modules/progs/helix/`).

Group modules follow the same option naming convention for
nexpr top-level modules. For example, file `./modules/foo/bar.nix`
will declare its options under `nexpr.foo.bar`.

Some group modules may not define any of their own options
and function more like a hook.

## Nexpr location

We can just have NixOS configuration directly import
the path to nexpr files.

However, arbitary locations will force users to  remember
where the location of the cloned repository was, and then
updating their Nix expressions in `/etc/nixos` to correctly
point to nexpr location.

To make it easy for all users, nexpr provides `stow.sh`, a Bash
script for stowing nexpr to these *well known* location,
e.g. `$HOME/.nexpr` and `$HOME/etc/nixos`.

## stow.sh

> ```
> Usage:
> stow.sh <HOST>
> ```

stow.sh helps link nexpr files and host files to your system.
By default, stow.sh stows all nexpr files to nexpr root `$HOME/.nexpr`.

If given a host (as 1st argument), then it also stows host's
`hardware-configuration` and `configuration.nix` expressions
to `/etc/nixos`.

### Examples

If we have the following files in our repository `nexpr`:

```
# nexpr

entrypoints
├── laptop
│   └── default.nix
├── server
│       ├── default.nix
│       └── wireguard.nix
└── workstation
    └── default.nix

modules/
├── wifi.nix
└── laptop-lid.nix

libnexpr/
└── ip.nix

hosts/
├── server
│   ├── configuration.nix
│   └── hardware-configuration.nix
└── laptop
    ├── configuration.nix
    └── hardware-configuration.nix
```

Then running `./stow.sh` (without the host argument) will result in
all nexpr files being linked to `$HOME/.nexpr`:

```
entrypoints
├── laptop
│   └── default.nix        -> $HOME/.nexpr/entrypoints/laptop/default.nix
├── server
│       ├── default.nix    -> $HOME/.nexpr/entrypoints/server/default.nix
│       └── wireguard.nix  -> $HOME/.nexpr/entrypoints/server/wireguard.nix
└── workstation
    └── default.nix        -> $HOME/.nexpr/entrypoints/workstation/default.nix

modules/
├── wifi.nix        -> $HOME/.nexpr/modules/wifi.nix
└── laptop-lid.nix  -> $HOME/.nexpr/modules/laptop-lid.nix

libnexpr/
└── ip.nix          -> $HOME/.nexpr/libnexpr/ip.nix

hosts/
├── server
│   ├── configuration.nix
│   └── hardware-configuration.nix
└── laptop
    ├── configuration.nix
    └── hardware-configuration.nix
```

But if we give it a host name with `./stow.sh laptop`,
then `/etc/nixos` gets populated too:

```
# nexpr
# ./stow.sh laptop;

entrypoints
├── laptop
│   └── default.nix        -> $HOME/.nexpr/entrypoints/laptop/default.nix
├── server
│       ├── default.nix    -> $HOME/.nexpr/entrypoints/server/default.nix
│       └── wireguard.nix  -> $HOME/.nexpr/entrypoints/server/wireguard.nix
└── workstation
    └── default.nix        -> $HOME/.nexpr/entrypoints/workstation/default.nix

modules/
├── wifi.nix        -> $HOME/.nexpr/modules/wifi.nix
└── laptop-lid.nix  -> $HOME/.nexpr/modules/laptop-lid.nix

libnexpr/
└── ip.nix          -> $HOME/.nexpr/libnexpr/ip.nix

hosts/
├── server
│   ├── configuration.nix
│   └── hardware-configuration.nix
└── laptop
    ├── configuration.nix          -> /etc/nixos/configuration.nix
    └── hardware-configuration.nix -> /etc/nixos/hardware-configuration.nix
```

To keep things simple, keep each host expressions within their own
directory, and avoid stowing more than 1 host to the same Nixos `/etc/nixos`.
