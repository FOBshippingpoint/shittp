#!/usr/bin/expect -f

source [file join [file dirname [info script]] lib/ssh_login.tcl]

exec /usr/sbin/sshd
spawn /bin/sh

ssh_login

send "vim\r"
expect {
  "超爽der 撿到一百塊勒" ok
  timeout                abort
}
