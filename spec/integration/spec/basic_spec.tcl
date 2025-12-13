#!/usr/bin/expect -f

source [file join [file dirname [info script]] ssh_login.tcl]

ssh_login
expect -ex {[shittp] Run this to initialize:}

send {. "$SHITTP"}
send "\r"
expect -ex {[shittp] Inited} ;# -ex = exact
