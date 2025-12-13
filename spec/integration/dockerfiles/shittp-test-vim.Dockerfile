FROM shittp-test-base:latest

RUN apk add --no-cache vim

RUN cat <<VIMRC >> "$SHITTP_CONFIG_DIR/.vimrc" 
!echo "超爽der 撿到一百塊勒"
q
VIMRC
