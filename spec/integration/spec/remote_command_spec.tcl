#!/usr/bin/expect -f

source [file join [file dirname [info script]] lib/ssh_login.tcl]

exec /usr/sbin/sshd
spawn /bin/sh

set keyfile {"$HOME/.ssh/id_ed25519"}
send "shittp -o 'StrictHostKeyChecking no' -i $keyfile -oRemoteCommand='test_profile' localhost\r"

expect {
  ".profile ready" ok
  timeout          abort
}
