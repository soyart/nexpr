# nexpr

Nix expressions and NixOS configurations

## Structure

> WARN: nexpr is currently being restrucured

> Note: we can symlink nexpr with [stow to nexpr root](#nexpr-location)
> (`$HOME/.nexpr`) with a non-Nixed Bash script [`stow.sh`](./stow.sh)

Nexpr is organized into directories, namely
- [host](./nixos/) and [home](./home/) configurations (top-level)
- [opinionated library](./libnexpr/)
- package lists in text files
