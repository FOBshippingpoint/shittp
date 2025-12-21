<div align="center">
<img alt="shittp logo" src="https://raw.githubusercontent.com/FOBshippingpoint/shittp/refs/heads/main/web/public/logo.svg"></img>
</div>

# shittp

> Bring your dotfiles to a remote machine via SSH without mess.

[![asciicast](https://asciinema.org/a/Pt8MvdHHmvzQPpitz8xWEA0jg.svg)](https://asciinema.org/a/Pt8MvdHHmvzQPpitz8xWEA0jg)

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
    john$ tmux   # alias equal to "tmux -L shittp -f $SHITTP_HOME/.tmux.conf"
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

## Help Information

```bash
shittp [options]... [command] [ssh_options]... destination [-- ssh_command]
```

### Options

| Option | Description | Default |
| --- | --- | --- |
| `-h`, `--help` | Show help message. |  |
| `--config-dir DIR` | Specify config directory. | `~/.config/shittp` |
| `--client CLIENT` | Specify SSH client command (e.g., `dbclient`). | `ssh` |
| `-v`, `--version` | Print shittp version. |  |

### Commands

| Command | Description |
| --- | --- |
| `where` | Show the default config directory path. |
| `print` | Output the command string instead of running SSH. Useful for loading dotfiles in environments like Docker. |

### Examples

Basic SSH Login

```bash
shittp john@example.com
```

Pass SSH options as is

```bash
shittp -oStrictHostKeyChecking=no john@example.com
```

Execute Remote Function

```bash
shittp john@example.com -- foo bar
shittp -oRemoteCommand='foo bar' john@example.com
```

Docker Integration

```bash
docker run -it alpine /bin/sh -c "$(shittp print)"
```

Dropbear Client

```bash
shittp --client dbclient john@example.com
```

### Environment Variables

| Variable | Scope | Description | Default |
| --- | --- | --- | --- |
| `SHITTP_CONFIG_DIR` | Local | Directory where your dotfiles live. | `~/.config/shittp` |
| `SHITTP_SSH_CLIENT` | Local | SSH client path (overridden by `--client`). | `ssh` |
| `SHITTP_SHELL` | Local/Remote | Shell path to use on the remote. | Remote login shell |
| `SHITTP_HOME` | Local/Remote | Directory to extract dotfiles tarball into. | Created temp directory |
| `SHITTP` | Remote | Path to `shittp_init.sh`. Source this if `[shittp] Inited` does not appear. |  |
| `SHITTP_INITED` | Remote | Set to `1` if shittp initialized successfully. |  |

### Limitations

Large cofig may fail to load due to the OS maximum argument length constraint (`ARG_MAX`). It is known that 100K file will trigger the error on Alpine Linux.

Command like `tar czf - | ssh host tar xzf -` should work, however this requires 2-stage SSH connection which means user need to type passphrase twice.

## Development

Required dependencies: shellcheck, shellspec, docker

### Makefile

```text
Specify a command. The choices are:

  help                 Show this help
  lint                 Run shellcheck
  unit                 Run unit test with shellspec
  integration          Run integration test script
  webdev               Start web server for home page
  build                Run all check (lint, unit, integration) and build tarball
  clean                Remove shittp tarball from the build step

```
