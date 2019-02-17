#!/bin/bash
# Nikita Slepogin (nikita.slepogin@gmail.com)
# Inspired by Junegunn Choi

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1
DOTFILES=$(pwd)

# Configs
for rc in vimrc; do
  [ -e ~/."$rc" ] && mv -v ~/."$rc" ~/."$rc".old
  ln -sfv "$DOTFILES/$rc" ~/."$rc"
done

# git-prompt
if [ ! -e ~/.git-prompt.sh ]; then
  curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o ~/.git-prompt.sh
fi

# scripts
mkdir -p ~/bin
for bin in $DOTFILES/bin/*; do
  ln -svf "$bin" ~/bin
done

# vim install
vim +PlugInstall +qall
