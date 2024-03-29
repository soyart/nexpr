# nixos-public

This repo hosts my Nix expressions for my Nixos machines.

The expressions are grouped into 2 categories:

- Modules

  - Modules are placed under directory [modules](./modules/)
    and are meant to be shared across machines.

  - Modules are symlinked to `/etc/nixos/modules` by [stow.sh](./stow.sh)

- Machines

  - Machines are machine-specific Nix expressions
    and are placed under arbitrary directory names such as [t14](./t14/)

  - Machines expressions must be manually copied into `/etc/nixos/`,
    although stow.sh may does it for you in the future
