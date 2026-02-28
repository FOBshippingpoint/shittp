FROM shittp-test-base:latest

RUN apk add --no-cache tmux

RUN cat <<TMUXCONF >> "$SHITTP_CONFIG_DIR/.tmux.conf" 
run-shell '> ~/tmuxbabe'
TMUXCONF
