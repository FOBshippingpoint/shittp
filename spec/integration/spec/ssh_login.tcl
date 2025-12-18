# Usage: source ssh_loging.tcl

exec /usr/sbin/sshd
spawn /bin/sh

proc ssh_login {} {
  set keyfile {"$HOME/.ssh/id_ed25519"}
  send "shittp -o 'StrictHostKeyChecking no' -i $keyfile localhost\r"
}
