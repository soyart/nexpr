#!/usr/bin/env bash

set -e;

halp() {
  echo "stow.sh [HOST]";
  echo "Stows modules and libnexpr to ~/home/.nexpr, and if <HOST> is provided, also stows hosts/<HOST> to /etc/nixos if given";
  exit 0;
}

case "$1" in
  "-h") halp ;;
  "help") halp ;;
  "--help") halp ;;
esac;

HOST="$1";

NIXOS_SYS_ROOT="/etc/nixos";
NEXPR_ROOT="$HOME/.nexpr";
# Files to linked to NEXPR_ROOT
NEXPR_DIRS=( \
  "modules" \
  "libnexpr" \
  "entrypoints" \
);

die() {
  local msg="$1";

  echo "die: $msg";
  exit 1;
}

stow_test() {
  local src="$1";
  local dst="$2";

  stow -n -t "$dst" "$src" > /dev/null 2>&1\
    || return 1;
}

stow_src_dst() {
  local src="$1";
  local dst="$2";

  test -z "$src" && die "stow_src_dst: missing src"
  test -z "$dst" && die "stow_src_dst: missing dst"
  test -f "$src" || die "stow_src_dst: src is not a directory: '$src'"
  test -d "$dst" || die "stow_src_dst: dst is not a directory: '$dst'"

  echo "stowing file $src -> $dst";

  if stow_test "$src" "$dst"; then
    stow -t "$dst" "$src" \
      || die "stow_src_dst: failed to stow $src";

  else
    die "stow_src_dst: dry-run failed for '$src' -> '$dst'";
  fi;
}

stow_pkg_src_dst() {
  local src="$1";
  local dst="$2";

  test -z "$src" && die "stow_pkg_src_dst: missing src"
  test -z "$dst" && die "stow_pkg_src_dst: missing dst"
  test -d "$src" || die "stow_pkg_src_dst: src is not a directory: '$src'"
  test -d "$dst" || die "stow_pkg_src_dst: dst is not a directory: '$dst'"
  
  echo "stowing pkg $src -> $dst";

  if stow_test "$src" "$dst"; then
    stow -t "$dst" "$src" \
      || die "stow_pkg_src_dst: failed to stow $src";

  else
    die "stow_pkg_src_dst: dry-run failed for '$src' -> '$dst'";
  fi;
}

stow_nexpr() {
  for d in "${NEXPR_DIRS[@]}"; do
    target="${NEXPR_ROOT}/${d}";

    if ! [ -d "$target" ]; then
      echo "Creating ${target}"
      mkdir -p "$target";
    fi;

    stow_pkg_src_dst "$d" "$target";
  done;


  echo "stow_nexpr: all done";
}

stow_host() {
  pushd "hosts" > /dev/null 2>&1;
  stow_pkg_src_dst "${HOST}" "${NIXOS_SYS_ROOT}";
  popd > /dev/null 2>&1;

  echo "stow_host: done: ${HOST}"
}

main() {
  mkdir -p "${NEXPR_ROOT}";
  stow_nexpr;
  test -n "${HOST}" && stow_host;
}

main;
