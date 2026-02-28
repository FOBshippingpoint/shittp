#!/usr/bin/expect -f

source [file join [file dirname [info script]] lib/ssh_login.tcl]

exec head -c 100k /dev/urandom > $::env(SHITTP_CONFIG_DIR)/large_file

exec /usr/sbin/sshd
spawn /bin/sh

ssh_login
expect {
  -ex {Argument list too long} ok
  timeout                      abort
}
