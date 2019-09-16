# If not running interactively, don't do anything
[ -z "$PS1" ] && return
[ -f ~/.git-prompt.sh ] && source ~/.git-prompt.sh

# Colors
__NOCOLOR="\[\033[00m\]"
__WHITE="\[\033[1;37m\]"
__BLACK="\[\033[0;30m\]"
__BLUE="\[\033[0;34m\]"
__LIGHT_BLUE="\[\033[1;34m\]"
__GREEN="\[\033[0;32m\]"
__LIGHT_GREEN="\[\033[1;32m\]"
__CYAN="\[\033[0;36m\]"
__LIGHT_CYAN="\[\033[1;36m\]"
__RED="\[\033[0;31m\]"
__LIGHT_RED="\[\033[1;31m\]"
__PURPLE="\[\033[0;35m\]"
__LIGHT_PURPLE="\[\033[1;35m\]"
__YELLOW="\[\033[0;33m\]"
__LIGHT_YELLOW="\[\033[1;33m\]"
__GRAY="\[\033[1;30m\]"
__LIGHT_GRAY="\[\033[0;37m\]"

if [ `id -u` == '0' ]; then
  __USER_COLOR=$__RED
else
  __USER_COLOR=$__NOCOLOR
fi

export GIT_PS1_SHOWDIRTYSTATE=yes
export PS1="\n${__LIGHT_BLUE}\w${__LIGHT_YELLOW}$(__git_ps1)\n${__USER_COLOR}\$ "

# Usefull functions
alias history_most_used="history | awk '{print \$2}' | awk 'BEGIN{FS=\"|\"}{print \$1}' | sort | uniq -c | sort -n | tail -n 20 | sort -nr"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux new-session -A -s main
fi
