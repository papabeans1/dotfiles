[[ -o interactive ]] || return

setopt autocd interactive_comments no_beep prompt_subst
setopt auto_pushd pushd_ignore_dups pushdminus

HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt append_history inc_append_history share_history
setopt hist_ignore_all_dups hist_ignore_space hist_reduce_blanks
setopt hist_find_no_dups hist_expire_dups_first hist_verify

export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-$EDITOR}"
export PAGER="${PAGER:-less}"
export LESS="-FRX"

autoload -Uz compinit vcs_info colors add-zsh-hook
colors
mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/.zcompdump"
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

if command -v eza >/dev/null 2>&1; then
  alias ls='eza --group-directories-first'
  alias ll='eza -la --git --group-directories-first'
  alias la='eza -a --group-directories-first'
else
  alias ls='ls -G'
  alias ll='ls -lahG'
  alias la='ls -AG'
fi

alias l='ll'
alias ..='cd ..'
alias ...='cd ../..'
alias gs='git status -sb'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull --rebase'
alias gco='git checkout'
alias k='kubectl'

hsearch() {
  [ -n "$1" ] || {
    echo "usage: hs <text>"
    return 1
  }
  if command -v rg >/dev/null 2>&1; then
    rg -n -i -- "$*" "$HISTFILE" | sed 's/^.*;//'
  else
    grep -ni -- "$*" "$HISTFILE" | sed 's/^.*;//'
  fi
}
alias hs='hsearch'

zstyle ':vcs_info:git:*' formats ' (%b)'
zstyle ':vcs_info:*' enable git
_prompt_vcs() { vcs_info; }
add-zsh-hook precmd _prompt_vcs
PROMPT='%F{39}%n%f %F{81}%~%f%F{244}${vcs_info_msg_0_}%f %# '

if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
