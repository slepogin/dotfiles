# if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
#   exec tmux new-session -A -s main
# fi

# Needed for tmux-256color config
export TERM="xterm-256color"

fpath+=("$HOME/.zsh/pure")

typeset -U path
path=(~/.local/bin $path[@])

autoload -U compinit promptinit
compinit
promptinit

prompt pure

zstyle ':completion:*' menu select
zstyle ':completion:*' completer _complete
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

alias ls='ls -G'
alias ll='ls -Gle'
# alias vim=nvim

source "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
source /usr/local/etc/profile.d/z.sh
# source "/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# source ~/.dotfiles/z.sh
# unalias z 2> /dev/null
# z() {
#   [ $# -gt 0 ] && _z "$*" && return
#   cd "$(_z -l 2>&1 | fzf --height 40% --nth 2.. --reverse --inline-info +s --tac --query "${*##-* }" | sed 's/^[0-9,.]* *//')"
# }

if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

export GOPATH="$HOME/Projects/go"

