#!/usr/bin/expect -f

source [file join [file dirname [info script]] ssh_login.tcl]

ssh_login
send "aloha\r"
expect {
  -ex {ALOHA~ de sho~} {
    exit 0
  }
  timeout {
    exit 1
  }
}
