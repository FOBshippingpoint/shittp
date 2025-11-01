#!/bin/sh

cleanup() {
  rm -rf "$tmpdir"
}

trap cleanup EXIT

msg() {
  IFS=" $IFS"
  set -- '%s\n' "${*:-}"
  IFS=${IFS#?}
  printf "$@"
}

die() {
  msg "$1"
  exit "${2:-1}"
}

: ${SHITTP_BIN_DIR:="$HOME/.local/bin"}
SHITTP_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.local/config}/shittp"

msg "$(
  cat <<'EOF'
   _____ _    _ _____ _______ _______            _____  
  / ____| |  | |_   _|__   __|__   __|          |  __ \ 
 | (___ | |__| | | |    | |     | |     ______  | |__) |
  \___ \|  __  | | |    | |     | |    |______| |  ___/ 
  ____) | |  | |_| |_   | |     | |             | |     
 |_____/|_|  |_|_____|  |_|     |_|             |_|     
EOF
)"

tmpdir=$(mktemp --directory)
cd "$tmpdir" || die "Cannot create temp directory."

msg "Download from GitHub..."
curl -fsSL https://github.com/FOBshippingpoint/shittp/archive/refs/heads/main.zip --output shittp.zip
unzip shittp.zip

if [ -d "$SHITTP_BIN_DIR" ]; then
  mv shittp-main/shittp "$SHITTP_BIN_DIR"
elif [ -e "$SHITTP_BIN_DIR" ]; then
  die "Executable directory [ "$SHITTP_BIN_DIR" ] is a file, expecting directory."
else
  die "Executable directory [ "$SHITTP_BIN_DIR" ] must exists."
fi

if [ -d "$SHITTP_CONFIG_DIR" ]; then
  msg "[ $SHITTP_CONFIG_DIR ] already exists, ignore."
else
  msg "Copying config to [ $SHITTP_CONFIG_DIR ]"
  mkdir -p "$SHITTP_CONFIG_DIR"
  mv -f shittp-main/config "$SHITTP_CONFIG_DIR"
fi

msg 'Installation complete :)'
