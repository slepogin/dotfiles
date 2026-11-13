#!/usr/bin/env bash
# Symlink the configs into $HOME. Safe to re-run.
# Anything already in the way is moved to <name>.bak.<timestamp>, never deleted.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
  local src="$DOTFILES/$1" dst="$2"
  if [[ -L $dst ]]; then
    if [[ $(readlink "$dst") == "$src" ]]; then
      echo "ok      $dst"
      return
    fi
    echo "relink  $dst (was -> $(readlink "$dst"))"
    rm "$dst"
  elif [[ -e $dst ]]; then
    local backup="$dst.bak.$(date +%Y%m%d%H%M%S)"
    echo "backup  $dst -> $backup"
    mv "$dst" "$backup"
  else
    echo "link    $dst"
  fi
  mkdir -p "$(dirname "$dst")"
  ln -s "$src" "$dst"
}

link zsh/zshrc "$HOME/.zshrc"
link nvim      "$HOME/.config/nvim"
link tmux      "$HOME/.config/tmux"

# Packages the configs rely on.
if command -v brew >/dev/null; then
  brew bundle --file="$DOTFILES/Brewfile" --no-upgrade
else
  echo "brew not found — install the packages listed in Brewfile yourself"
fi

echo "Done. Restart the shell; nvim installs its plugins on first start."
