letup() {
  for varname in "$@"; do
    val=$(eval echo "\$$varname")
    printf '[Letup] %s=%s\n' "$varname" "$val"
    export "$varname"
  done
  echo "[Letup] You are in subshell now."
  ${SHELL:-/bin/sh} -i &&:
  echo "[Letup] You leave the subshell."
}
