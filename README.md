<div align="center">
<img alt="shittp logo" src="https://raw.githubusercontent.com/FOBshippingpoint/shittp/2db5ed4609b565fd8b3158b8e934064432f9347e/logo.svg"></img>
</div>

# shittp

Bring your dotfiles to a remote machine via SSH.

## How It Works

shittp uses `tar` to create gzipped tar archive of your dotfiles, converts the archive to base64 format (i.e., readable characters), and passes base64 string as a remote command on the other machine via SSH. Finally, it decodes base64 string and uses `tar` to restore the dotfiles.

The original idea comes from [kyrat](https://github.com/fsquillace/kyrat), which uses `gzip`/`gunzip` instead of `tar` and is written in bash. 

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
    echo 'aloha() { echo hello; }' >> ~/.bashrc
    $EDITOR .vimrc
    $EDITOR .tmux.conf
    ```

2. Login to remote host
    ```sh
    shittp john@other.machine
    john> aloha  # output: hello
    john> vim    # an alias equivalent to "vim -u $SHITTP_HOME/.vimrc"
    john> tmux   # an alias equivalent to "tmux -f $SHITTP_HOME/.tmux.conf"
    ```

