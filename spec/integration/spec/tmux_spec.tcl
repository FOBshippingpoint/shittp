#!/usr/bin/expect -f

source [file join [file dirname [info script]] lib/ssh_login.tcl]

exec /usr/sbin/sshd
spawn /bin/sh

ssh_login

send "tmux new-session -d\r"
send "test -f ~/tmuxbabe && echo ok\r"
expect {
  "ok"    ok
  timeout abort
}
