FROM alpine:3.23.0

ENV SHITTP_CONFIG_DIR=/etc/shittp

RUN apk add --no-cache openssh expect

COPY config $SHITTP_CONFIG_DIR
COPY shittp /usr/local/bin
COPY --chmod=+x spec/integration/spec /spec

RUN <<EOF
# Generate hostkeys
ssh-keygen -A
# Generate key without passphrase and add public key to authorized_keys
ssh-keygen -t ed25519 -f "$HOME/.ssh/id_ed25519" -N ''
cat "$HOME/.ssh/id_ed25519.pub" > "$HOME/.ssh/authorized_keys"
echo 'test_profile() { echo ".profile ready"; }' >> "$SHITTP_CONFIG_DIR/.profile"
EOF

