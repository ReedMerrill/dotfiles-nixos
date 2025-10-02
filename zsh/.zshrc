# disable ctrl-l clearing the screen
bindkey -r "^L"

# make arguments to cd that aren't directories assumed to be a variable who's
# value is a directory. Useful for "aliasing" directories
setopt cdablevars
# turn on dir switching without cd
setopt autocd

# hyphen-insensitive completion.
HYPHEN_INSENSITIVE="true"

COMPLETION_WAITING_DOTS="true"

plugins=(git)

# set editor
export EDITOR="$(which nvim)"

# modify path
export PATH="$PATH:$HOME/go/bin:$HOME/Scripts"

################################################################################
# ALIASES & HASHES (MacOS only)

# source main aliases script
source ~/.aliases

# stop using BSD sed, start using GNU sed
alias sed="gsed"

# listing (eza is an awesome ls replacement)
alias l="eza -l --icons --git --all --modified"
# list with 2-level tree
alias lt="eza --tree --level=2 --all --long --icons --git --modified"

# Directory Navigation

# fixing annoying mandatory [d]rop[b]ox folder name on linked account
# [n]eovim [d]ot[f]iles
alias ndf='cd ~/dotfiles/nvim/.config/nvim/ && nvim .'
# [d]ot[f]iles
alias df='cd ~/dotfiles/ && nvim .'

################################################################################
# Pomodoro

function work() {
  local duration="${1:-55m}"
  timer "$duration" && terminal-notifier -message 'Pomodoro' \
    -title 'Work Timer is up! Take a Break 😊' \
    -appIcon "$HOME/Pictures/pumpkin.png" \
    -sound Crystal
}

function rest() {
  local duration="${1:-5m}"
  timer "$duration" && terminal-notifier -message 'Pomodoro' \
    -title 'Break is over! Get back to work 😬' \
    -appIcon "$HOME/Pictures/pumpkin.png" \
    -sound Crystal
}

################################################################################
# INITIALIZATIONS

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
source <(fzf --zsh)

# Automatically activate venv if in project directory
function cd() {
  builtin cd "$@" || return 1

  if [ -d "venv" ]; then
    if [ -z "$VIRTUAL_ENV" ]; then
      # Activate virtual environment if not already active
      source venv/bin/activate
    fi
  else
    # Deactivate venv if it was activated and we're leaving the project directory
    if [ -n "$VIRTUAL_ENV" ]; then
      deactivate
    fi
  fi
}
