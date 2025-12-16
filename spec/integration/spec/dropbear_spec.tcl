#!/usr/bin/expect -f

exec /usr/sbin/sshd
spawn /bin/sh

set keyfile {"$HOME/.ssh/id_dropbear"}

# -y -y to bypass host key checking
send "shittp --ssh-client dbclient -i $keyfile -y -y localhost\r"
expect {
  -ex {. "$SHITTP"} {}
  timeout {
    exit 1
  }
}
send {. "$SHITTP"}
send "\r"
expect {
  -ex {[shittp] Inited} {
    exit 0
  }
  timeout {
    exit 1
  }
}
