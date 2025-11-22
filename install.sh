#!/bin/sh

set -eu

cleanup() {
  [ "${tmpdir:-}" ] && rm -rf "$tmpdir"
}

trap cleanup EXIT

msg() {
  IFS=" $IFS"
  set -- '%s\n' "${*:-}"
  IFS=${IFS#?}
  printf "$@"
}

die() {
  [ "${1:-}" ] && msg "$1"
  exit "${2:-1}"
}

require() {
  while [ $# -gt 0 ]; do
    hash "$1" 2>/dev/null || {
      msg "Dependency [ $1 ] is required";
      failed=1
    }
    shift
  done
  [ "${failed:-}" ] && return 1
}

confirm() {
  msg "$1"
  default=${2-no}
  while IFS= read -r response; do
    is_yes "$response" && return 0 ||
      case $response in
        [Nn] | [Nn][Oo])
          return 1
        ;;
        *)
          if [ "${default:-}" ]; then
            is_yes "$default" && return 0 || return 1;
          fi
          echo 'Yes or No?'
        ;;
      esac
  done
}

is_yes() {
  case $1 in
    [Yy]|[Yy][Ee][Ss])
      return 0
    ;;
    *)
      return 1
    ;;
  esac
}

usage() {
  cat <<'USAGE'
shittp installer

Usage: install.sh [options]...

Options:
  -b, --bin BIN            Specify bin directory            [default: ~/.local/bin]
  -c, --config-dir DIR     Specify default config directory [default: ~/.config]
  --from github|here       Specify installation source      [default: github]
                           - github: download zip from GitHub main branch
                           - here:   install from the script directory, assume that you had clone the repository
  -y, --yes                Automatic yes to prompts
  -h, --help               You're looking at it

Examples:
  ./install.sh --from here -y  # Install from local repository and yes to everything
  ./install.sh -b /usr/bin     # Install to /usr/bin instead of default ~/.local/bin directory

USAGE
  exit 0
}

: ${SHITTP_SRC:=github}
: ${SHITTP_BIN_DIR:="$HOME/.local/bin"}
: ${SHITTP_CONFIG_DIR:="${XDG_CONFIG_HOME:-$HOME/.config}"}
YES=0

while [ $# -gt 0 ]; do
  case $1 in
    -h | --help)
      usage
    ;;
    -b | --bin)
      case ${2:--} in -*) die "BIN of option [ $1 ] not specified" ;; esac
      SHITTP_BIN_DIR=$2 && shift
    ;;
    -c | --config-dir)
      case ${2:--} in -*) die "DIR of option [ $1 ] not specified" ;; esac
      SHITTP_CONFIG_DIR="$2" && shift
    ;;
    -y | --yes)
      YES=1
    ;;
    --from)
      case ${2:-} in
        github | here)
          SHITTP_SRC=$2
          shift
        ;;
        *)
          die "SRC of option [ $1 ] must be 'github' or 'here'"
        ;;
      esac
    ;;
    *)
      die "Unknown option $1"
    ;;
  esac
  shift
done

cat <<'EOF'
   _____ _    _ _____ _______ _______            _____  
  / ____| |  | |_   _|__   __|__   __|          |  __ \ 
 | (___ | |__| | | |    | |     | |     ______  | |__) |
  \___ \|  __  | | |    | |     | |    |______| |  ___/ 
  ____) | |  | |_| |_   | |     | |             | |     
 |_____/|_|  |_|_____|  |_|     |_|             |_|     
EOF

echo "
---
Executable file     : $SHITTP_BIN_DIR/shittp
Config directory    : $SHITTP_CONFIG_DIR/shittp
Installation source : $SHITTP_SRC
---"

if ! [ "$YES" = 1 ]; then
  if ! confirm "Is that good? [Y/n]" yes; then
    die 'Cancelled'
  fi
fi

install_sh=$0
script_dir=$(dirname "$install_sh")

if [ "$SHITTP_SRC" = here ]; then
  echo 'Install from script directory...'
  src=$script_dir
else
  require curl unzip mktemp
  tmpdir=$(mktemp --directory || die "Cannot create temp directory")
  cd "$tmpdir"
  echo 'Downloading from GitHub...'
  curl -fsSL https://github.com/FOBshippingpoint/shittp/archive/refs/heads/main.zip --output shittp.zip
  unzip shittp.zip
  src=shittp-main # The unzipped directory is 'shitp-main'
fi

if [ -e "$SHITTP_BIN_DIR/shittp" ]; then
  if [ "$YES" = 1 ] || confirm "Bin [ $SHITTP_BIN_DIR/shittp ] already exists, overwrite? [y/N]"; then
    cp -f "$src/shittp" "$SHITTP_BIN_DIR" || die "Failed to copy bin to [ $SHITTP_BIN_DIR ]"
  else
    die 'Cancelled'
  fi
else
  cp "$src/shittp" "$SHITTP_BIN_DIR" || die "Failed to copy bin to [ $SHITTP_BIN_DIR ]"
fi

if [ -d "$SHITTP_CONFIG_DIR/shittp" ]; then
  if [ "$YES" = 1 ] || confirm "Config [ $SHITTP_CONFIG_DIR/shittp ] already exists, overwrite? [y/N]"; then
    rm -rf "$SHITTP_CONFIG_DIR/shittp" || die "Failed to overwrite config to [ $SHITTP_CONFIG_DIR/shittp ]"
    cp -rf "$src/config" "$SHITTP_CONFIG_DIR/shittp" || die "Failed to overwrite config to [ $SHITTP_CONFIG_DIR/shittp ]"
  fi
else
  mkdir -p "$SHITTP_CONFIG_DIR" || die "Failed to create config directory [ $SHITTP_CONFIG_DIR ]"
  cp -rf "$src/config" "$SHITTP_CONFIG_DIR/shittp" || die "Failed to move config to [ $SHITTP_CONFIG_DIR/shittp ]"
fi

echo 'Installation complete :)'
