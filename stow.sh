#!/usr/bin/env bash

NIXMOD="/etc/nixos/modules";

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

  test -z "$src" && die "stow_pkg_to: missing src"
  test -z "$dst" && die "stow_pkg_to: missing dst"
  test -d "$src" || die "stow_pkg_to: src is not a directory: '$src'"
  test -d "$dst" || die "stow_pkg_to: dst is not a directory: '$dst'"
  
  echo "stowing $src -> $dst";

  if stow_test "$src" "$dst"; then
    sudo stow -t "$dst" "$src"\
      && echo "stowed $dst: $src"\
      || die "stow_pkg_to: failed to stow $src";
    

  else
    die "stow_pkg_to: dry-run failed for '$src' -> '$dst'";
  fi;
}

stow_modules() {
  test -d "${NIXMOD}" || die "stow_modules: NIXMOD is not a directory: '${NIXMOD}'";
  stow_src_dst "modules" "$NIXMOD";
}

main() {
  if ! [ -d "${NIXMOD}" ]; then
    echo "Creating ${NIXMOD}";
    sudo mkdir -p "${NIXMOD}";
  fi;

  stow_modules;
}

main;

