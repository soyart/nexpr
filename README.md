# nexpr (Nix expressions)

The expressions are grouped into 3 categories:

- Entrypoints

  - Entrypoints are top-level machine-specific Nix expressions,
    replacing `/etc/configuration.nix` in traditional NixOS setup

  - Entrypoints are named "${NAME}.nix",
    and are symlinked to `$HOME/.nixos/$NAME.nix` by [stow.sh](./stow.sh)

- Modules

  - Modules are placed under directory [modules](./modules/)
    and are meant to be shared across machines.

  - Modules are symlinked to `/$HOME/.nixos/modules` by [stow.sh](./stow.sh)

- Hosts

  - Hosts are machine-specific Nix expressions
    and are placed under [`hosts`](./hosts/) with
    arbitrary directory names such as [hosts/t14](./hosts/t14/)

  - Host files are 2 files per machine, a `configuration.nix`
    and `hardware-configuration.nix`

  - Host expressions are symlinked to `/etc/nixos`


## stow.sh

> ```
> Usage:
> stow.sh <HOST>
> ```

By default, it symlinks every module to `$HOME/.nixos/modules`,
and puts all entrypoints in `$HOME/.nixos`.

If given a host (as 1st argument), then it also stows host's
`hardware-configuration` and `configuration.nix` expressions
to `/etc/nixos`.

### Examples

If we have the following files in our repository `nexpr`:

```
# nexpr

entrypoints/
├── laptop.nix
├── server.nix
└── desktop.nix

modules/
├── wifi.nix
└── laptop-lid.nix

hosts/
├── server
│   ├── configuration.nix
│   └── hardware-configuration.nix
└── laptop
    ├── configuration.nix
    └── hardware-configuration.nix
```

Then running `./stow.sh` (without the host argument) will result in
all entrypoints and modules being linked to `$HOME/.nixos`:

```
# nexpr
# ./stow.sh;

entrypoints/
├── laptop.nix      -> $HOME/.nixos/entrypoints/laptop.nix
├── server.nix      -> $HOME/.nixos/entrypoints/server.nix 
└── desktop.nix     -> $HOME/.nixos/entrypoints/desktop.nix 

modules/
├── wifi.nix        -> $HOME/.nixos/modules/wifi.nix
└── laptop-lid.nix  -> $HOME/.nixos/modules/laptop-lid.nix

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

entrypoints/
├── laptop.nix      -> $HOME/.nixos/entrypoints/laptop.nix
├── server.nix      -> $HOME/.nixos/entrypoints/server.nix 
└── desktop.nix     -> $HOME/.nixos/entrypoints/desktop.nix 

modules/
├── wifi.nix        -> $HOME/.nixos/modules/wifi.nix
└── laptop-lid.nix  -> $HOME/.nixos/modules/laptop-lid.nix

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

Instead, shared expressions are encouraged to be put in modules.
