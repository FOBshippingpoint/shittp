FROM shittp-test-base:latest

RUN apk add --no-cache bash

ENV SHITTP_SHELL=/bin/bash

RUN echo 'aloha() (echo "ALOHA~ de sho~")' >> "$SHITTP_CONFIG_DIR/.bashrc"
