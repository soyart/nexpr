# nixos-public

This repo hosts my Nix expressions for Nixos.

The expressions are grouped into 2 categories:

- Modules

  - Modules are placed under directory [modules](./modules/)
    and are meant to be shared across machines.

  - Modules are symlinked to `/etc/nixos/modules` by [stow.sh](./stow.sh)

- Hosts

  - Hosts are machine-specific Nix expressions
    and are placed under [`hosts`](./hosts/) with
    arbitrary directory names such as [hosts/t14](./hosts/t14/)

  - Host expressions are symlinked to `/etc/nixos`

## stow.sh

> ```
> Usage:
> stow.sh <HOST>
> ```

stow.sh helps you stow your expressions into `/etc/{nixos,nixos/modules}`.

By default, it symlinks every module to `/etc/nixos/modules`, and,
if given a host (as 1st argument), then it also stows host-specific
expressions into `/etc/nixos`.

E.g. if we have the following files in our repository:

```
# nixos-public

modules
├── wifi.nix
└── laptop-lid.nix

hosts/
├── server
│   ├── configuration.nix
│   ├── ssh-auth.nix
│   ├── firewall.nix
│   └── hardware-configuration.nix
└── laptop
    ├── configuration.nix
    └── hardware-configuration.nix
```

Then running `./stow.sh` (without the host argument) will result in
all modules being linked to `/etc/nixos/modules`:

```
# nixos-public
# ./stow.sh;

modules             -> /etc/nixos/modules
├── wifi.nix        -> /etc/nixos/modules/wifi.nix
└── laptop-lid.nix  -> /etc/nixos/modules/laptop-lid.nix

hosts/
├── server
│   ├── configuration.nix
│   ├── ssh-auth.nix
│   ├── firewall.nix
│   └── hardware-configuration.nix
└── laptop
    ├── configuration.nix
    └── hardware-configuration.nix
```

But if we re-run with `./stow.sh laptop`, then:

```
# nixos-public
# ./stow.sh laptop;

modules             -> /etc/nixos/modules
├── wifi.nix        -> /etc/nixos/modules/wifi.nix
└── laptop-lid.nix  -> /etc/nixos/modules/laptop-lid.nix

hosts/
├── server
│   ├── configuration.nix
│   ├── ssh-auth.nix
│   ├── firewall.nix
│   └── hardware-configuration.nix
└── laptop
    ├── configuration.nix          -> /etc/nixos/configuration.nix
    └── hardware-configuration.nix -> /etc/nixos/hardware-configuration.nix
```

To keep things simple, keep each host expressions within their own
directory, and avoid stowing more than 1 host to the same Nixos `/etc`.

Instead, shared expressions are encouraged to be put in modules.
