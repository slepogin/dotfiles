#!/bin/bash
# Nikita Slepogin (nikita.slepogin@gmail.com)
# Inspired by Junegunn Choi

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1
DOTFILES=$(pwd)

log() {
    white="\033[1;37m"
    red="\033[0;31m"
    reset="\033[00m"

    level=$1 && shift
    case "$level" in
        error) echo -e  "${red}$@${reset}" 1>&2 ;;
        info) echo -e "${white}$@${reset}" 1>&2 ;;
        debug) echo -e  "$@" 1>&2 ;;
    esac
}

log info "Installing configs"

for rc in *{rc,conf}; do
  [ -e ~/."$rc" ] && mv -v ~/."$rc" ~/."$rc".old
  ln -sfv "$DOTFILES/$rc" ~/."$rc"
done

if [ ! -e ~/.git-prompt.sh ]; then
  log info "Installing git-prompt.sh"
  curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o ~/.git-prompt.sh
fi

log info "Installing scripts"
mkdir -p ~/bin
for bin in $DOTFILES/bin/*; do
  ln -svf "$bin" ~/bin
done

log info "Running vim with PlugInstall"
vim +PlugInstall +qall
