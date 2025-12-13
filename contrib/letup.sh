letup() {
  for varname in "$@"; do
    eval "val=\$$varname"
    printf '[Letup] %s=%s\n' "$varname" "$val"
    export "$varname"
  done
  echo "[Letup] You are in subshell now."
  ${SHELL:-/bin/sh}
  echo "[Letup] You leave the subshell."
}
