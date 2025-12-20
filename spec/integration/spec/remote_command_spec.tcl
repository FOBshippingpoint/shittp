#!/usr/bin/expect -f

source [file join [file dirname [info script]] ssh_login.tcl]

set keyfile {"$HOME/.ssh/id_ed25519"}
send "shittp -o 'StrictHostKeyChecking no' -i $keyfile -oRemoteCommand='test_profile' localhost\r"

expect {
  ".profile ready" {
    exit 0
  }
  timeout {
    exit 1
  }
}
