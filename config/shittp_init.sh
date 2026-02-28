#===================[ ~/.config/shittp/shittp_init.sh ]===================
#
# This file will run after your shell start.
# The snippet below make sure that ~/.profile script get sourced.
#
#===================[ EDIT WITH CAUTION ]=================================
dot_coalesce() {
  while [ $# -gt 0 ]; do
    if [ -r "$1" ]; then
      . "$1" && return
    fi
    shift
  done
}

case ${SHELL:-} in
  *bash*) dot_coalesce ~/.bash_profile ~/.bash_login ~/.profile ;;
       *) 
         if [ ! "${ZDOTDIR:-}" ]; then
           dot_coalesce ~/.profile
         fi
       ;;
esac
#===================[ EDIT WITH CAUTION ]=================================


# Feel free to add your commands below:
