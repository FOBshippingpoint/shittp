#===================[ ~/.config/shittp/shittp_init.sh ]===================

# Feel free to edit this file.
# You can check the original file at: https://github.com/FOBshippingpoint/shittp/blob/main/config/shittp_init.sh

tmux_conf="$SHITTP_HOME/.tmux.conf"
vimrc="$SHITTP_HOME/.vimrc"
inputrc="$SHITTP_HOME/.inputrc"
overwrite_aliases=0

is_alias_exists() {
  alias "$1" >/dev/null 2>&1
}

if [ -e "$tmux_conf" ]; then
  if ! is_alias_exists tmux || [ "$overwrite_aliases" = 1 ]; then
    alias tmux="tmux -f $tmux_conf"
  fi
fi


if [ -e "$vimrc" ]; then
  if ! is_alias_exists vim || [ "$overwrite_aliases" = 1 ]; then
    alias vim="vim -u $vimrc"
  fi
fi


if [ -e "$inputrc" ]; then
  export INPUTRC=$inputrc
fi
