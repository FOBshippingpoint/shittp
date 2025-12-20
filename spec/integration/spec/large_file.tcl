#!/usr/bin/expect -f

source [file join [file dirname [info script]] ssh_login.tcl]

exec head -c 100k /dev/urandom > $::env(SHITTP_CONFIG_DIR)/large_file

ssh_login
expect {
  -ex {Argument list too long} {
    exit 0
  }
  timeout {
    exit 1
  }
}
