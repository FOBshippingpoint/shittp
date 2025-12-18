#!/usr/bin/expect -f

source [file join [file dirname [info script]] ssh_login.tcl]

ssh_login

send "type vim\r"
expect {
  "vim is an alias for vim -u" {} ;# ignore the /tmp/blah/.vimrc part 
  timeout {
    exit 1
  }
}

send "vim\r"
expect {
  "超爽der 撿到一百塊勒" {
    exit 0
  }
  timeout {
    exit 1
  }
}
