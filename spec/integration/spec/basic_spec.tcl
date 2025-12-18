#!/usr/bin/expect -f

source [file join [file dirname [info script]] ssh_login.tcl]

ssh_login
expect {
  -ex {[shittp] Inited} {
    exit 0
  }
  timeout {
    exit 1
  }
}
