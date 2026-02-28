FROM shittp-test-base:latest

RUN apk add --no-cache zsh

ENV SHITTP_SHELL=/bin/zsh

RUN echo 'aloha() (echo "ALOHA~ de sho~")' >> "$SHITTP_CONFIG_DIR/.zshrc"
