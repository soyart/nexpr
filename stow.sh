#!/usr/bin/env bash

set -e;

halp() {
  echo "stow.sh [HOST]";
  echo "Stows modules to /etc/nixos/modules, and hosts/<HOST> to /etc/nixos if given";
  exit 0;
}

case "$1" in
  "-h") halp ;;
  "help") halp ;;
  "--help") halp ;;
esac;

HOST="$1";
NIXOS_SYS_ROOT="/etc/nixos";
NIXOS_HOME="$HOME/.nixos";
NIXOS_MODS="$HOME/.nixos/modules";

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

stow_modules() {
  test -d "${NIXOS_MODS}" || die "stow_modules: NIXOS_MODS is not a directory: '${NIXOS_MODS}'";

  stow_pkg_src_dst "entrypoints" "${NIXOS_HOME}";
  stow_pkg_src_dst "modules" "${NIXOS_MODS}";

  echo "stow_modules: done";
}

stow_host() {
  pushd "hosts" > /dev/null 2>&1;
  stow_pkg_src_dst "${HOST}" "${NIXOS_SYS_ROOT}";
  popd > /dev/null 2>&1;

  echo "stow_host: done: ${HOST}"
}

main() {
  if ! [ -d "${NIXOS_MODS}" ]; then
    echo "Creating ${NIXOS_MODS}";
    mkdir -p "${NIXOS_MODS}";
  fi;

  stow_modules;

  test -n "${HOST}" && stow_host;
}

main;
