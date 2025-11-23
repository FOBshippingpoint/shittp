# shittp

Bring your dotfiles to remote machine via SSH.

## How It Works

shittp use `tar` to create gzipped tar archive of your dotfiles, and convert the archive to base64 format (i.e., readable characters), pass base64 string as remote command on the other machine via SSH. Finally, decode base64 string and use `tar` to extract back to the dotfiles.

The original idea comes from [kyrat](https://github.com/fsquillace/kyrat), which use `gzip`/`gunzip` instead of `tar` and is written in bash. 

## Installation

Required dependencies: POSIX shell, ssh, tar, base64, mktemp

```sh
curl -fsSL https://raw.githubusercontent.com/FOBshippingpoint/shittp/refs/heads/main/install.sh --output install.sh
chmod +x install.sh
./install.sh
```

## Usage

1. Edit your dotfiles in `~/.config/shittp`
    ```sh
    cd ~/.config/shittp
    echo 'hi_from_local_bashrc() { echo hello; }' >> .bashrc
    $EDITOR .vimrc
    $EDITOR .tmux.conf
    ```

2. Login to remote host
    ```sh
    shittp john@other.machine
    john> hi_from_local_bashrc  # output: hello
    john> vim                   # from alias vim="vim -u $SHITTP_HOME/.vimrc"
    john> tmux                  # from alias tmux="tmux -f $SHITTP_HOME/.tmux.conf"
    ```
