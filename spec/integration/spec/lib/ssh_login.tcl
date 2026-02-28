set timeout 5

proc ssh_login {} {
  set keyfile {"$HOME/.ssh/id_ed25519"}
  send "shittp -o 'StrictHostKeyChecking no' -i $keyfile localhost\r"
}

proc abort {} {
  send_user "expect timeout"
  exit 1
}

proc ok {} {
  send_user "test passed"
  exit 0
}
