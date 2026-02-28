#!/usr/bin/expect -f

source [file join [file dirname [info script]] lib/ssh_login.tcl]

exec /usr/sbin/sshd
spawn /bin/sh

ssh_login
expect {
  -ex {[shittp] Inited} { }
  timeout               abort
}

send "test_profile\r"
expect {
  ".profile ready" ok
  timeout          abort
}
