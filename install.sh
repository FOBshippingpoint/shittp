#!/bin/sh

SHITTP_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.local/config}/shittp"

tmpdir=$(mktemp --directory)
cd "$tmpdir" || exit 1
curl -fsSL https://github.com/FOBshippingpoint/shittp/archive/refs/heads/main.zip --output shittp.zip
unzip shittp.zip

# TODO: specify executable location
mkdir -p "$HOME/.local/bin"
mv shittp "$HOME/.local/bin"

if [ -d "$SHITTP_CONFIG_DIR" ]; then
  echo "[ $SHITTP_CONFIG_DIR ] already exists, ignore"
else
  mkdir -p "$SHITTP_CONFIG_DIR"
  mv -f config "$SHITTP_CONFIG_DIR"
fi

