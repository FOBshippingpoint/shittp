<div align="center">
<img alt="shittp logo" src="https://raw.githubusercontent.com/FOBshippingpoint/shittp/refs/heads/main/logo.svg"></img>
</div>

# shittp

> Bring your dotfiles to a remote machine via SSH without mess.

## Installation

Required dependencies: **POSIX shell**, **ssh**, **tar**, **base64**, **mktemp**

```sh
curl -fsSL https://raw.githubusercontent.com/FOBshippingpoint/shittp/refs/heads/main/install.sh --output install.sh
chmod +x install.sh
./install.sh
```

## Usage

1. Edit your dotfiles in `~/.config/shittp`
    ```sh
    cd ~/.config/shittp 
    echo 'aloha() { echo hello; }' >> .profile
    $EDITOR .vimrc
    $EDITOR .tmux.conf
    ```

2. Login to remote host with SSH:
    ```sh
    shittp john@other.machine
    john$ aloha  # output: hello
    john$ vim    # alias equal to "vim -u $SHITTP_HOME/.vimrc"
    john$ tmux   # alias equal to "tmux -f $SHITTP_HOME/.tmux.conf"
    ```
    Or Docker container:
    ```sh
    docker run -it alpine /bin/sh -c "$(shittp print)"
    $ aloha    # output: hello
    ```

## How It Works

1.  **Pack:** create a tarball of your dotfiles and pipes to base64 string.
2.  **Transport:** passing the base64 string and setup script as a SSH remote command.
3.  **Unpack:** on the remote, decodes base64 string and extracts to temp directory.
4.  **Init:** sources setup script and start an interactive shell.
5.  **Cleanup:** remove temp directory once disconnect.

The original idea comes from [kyrat](https://github.com/fsquillace/kyrat), which uses `gzip`/`gunzip` and `bash`. shittp uses tar and POSIX shell.

## Development

### Testing

Required dependencies: shellspec, docker

```sh
# Unit test
shellspec

# Integration test
sudo spec/integration/run.sh
```
