# If not running interactively, don't do anything
[ -z "$PS1" ] && return

RESET="\[\033[00m\]"
WHITE="\[\033[1;37m\]"
BLACK="\[\033[0;30m\]"
BLUE="\[\033[0;34m\]"
LIGHT_BLUE="\[\033[1;34m\]"
GREEN="\[\033[0;32m\]"
LIGHT_GREEN="\[\033[1;32m\]"
CYAN="\[\033[0;36m\]"
LIGHT_CYAN="\[\033[1;36m\]"
RED="\[\033[0;31m\]"
LIGHT_RED="\[\033[1;31m\]"
PURPLE="\[\033[0;35m\]"
LIGHT_PURPLE="\[\033[1;35m\]"
YELLOW="\[\033[0;33m\]"
LIGHT_YELLOW="\[\033[1;33m\]"
[[ $TERM =~ "256" ]] && GRAY="\[\033[38;5;242m\]" || GRAY="\[\033[1;30m\]"
LIGHT_GRAY="\[\033[0;37m\]"

PURE_PROMPT_SYMBOL="❯"

# git-prompt
# if [ ! -e ~/.git-prompt.sh ]; then
#       curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o ~/.git-prompt.sh
# fi
__git_ps1() { :;}
[ -f ~/.git-prompt.sh ] && source ~/.git-prompt.sh
[[ -n $SSH_CLIENT ]] && SSH_HOSTNAME="\u@\h" || SSH_HOSTNAME=""

export GIT_PS1_SHOWDIRTYSTATE=yes
PS1="\n${BLUE}\w"
PS1+="${GRAY}\$(__git_ps1 \" %s\") "
PS1+="${SSH_HOSTNAME}\n"
PS1+="${LIGHT_PURPLE}${PURE_PROMPT_SYMBOL}${RESET} "
export PS1

# Usefull functions
alias history_most_used="history | awk '{print \$2}' | awk 'BEGIN{FS=\"|\"}{print \$1}' | sort | uniq -c | sort -n | tail -n 20 | sort -nr"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

man () {
    LESS_TERMCAP_mb=$'\e'"[1;34m" \
    LESS_TERMCAP_md=$'\e'"[1;34m" \
    LESS_TERMCAP_me=$'\e'"[0m" \
    LESS_TERMCAP_se=$'\e'"[0m" \
    LESS_TERMCAP_so=$'\e'"[1;44;33m" \
    LESS_TERMCAP_ue=$'\e'"[0m" \
    LESS_TERMCAP_us=$'\e'"[1;32m" \
    command man "$@"
}

if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux new-session -A -s main
fi
