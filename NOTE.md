# NOTE

## TODO

- [x] Maybe we can add a command to output only the remote script? so that we can bring the dotfiles to docker??
- [ ] should add note about the limitations (e.g., \[source\] will not work if the file not in the shittp config dir)
- [ ] Add check on the remote-side, if it don't have tar, mktemp, base64??
- [ ] Should we early return shittp_init.sh (dot script) if SHITTP_INITED=1? However this requires insert a new line at top of file, when I try to use printf, we got percent_expand: unknown key %s error, because OpenSSH's % expansion: https://man.openbsd.org/ssh_config#TOKENS
