FROM shittp-test-base:latest

RUN apk add --no-cache dropbear dropbear-dbclient

RUN <<EOF
dropbearkey -t rsa -f "$HOME/.ssh/id_dropbear"
cat "$HOME/.ssh/id_dropbear.pub" > "$HOME/.ssh/authorized_keys"
EOF
