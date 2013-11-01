export RUBY_HEAP_MIN_SLOTS=1000000
export RUBY_HEAP_SLOTS_INCREMENT=1000000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
export RUBY_GC_MALLOC_LIMIT=1000000000
export RUBY_HEAP_FREE_MIN=500000


if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
  export TERM=gnome-256color
elif infocmp xterm-256color >/dev/null 2>&1; then
  export TERM=xterm-256color
fi

tput sgr0
YELLOW=$(tput setaf 3)
GREEN=$(tput setaf 2)
GREEN_DARK=$(tput setaf 28)
WHITE=$(tput setaf 255)
RED=$(tput setaf 1)

function ruby_info() {
  ruby_version=$(ruby -e "print RUBY_VERSION")
  echo "ruby($ruby_version)"
}

function parse_git_dirty() {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit, working directory clean" ]]
}

function parse_git_branch {
  branch=$(git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/")
  if [[ $branch != "" ]]; then
    echo ":branch($branch)"
  fi
}

function brails {
  RAILS_ENV=$1 bundle exec rails $2
}

# PS1="\033[G\[${BOLD}${GREEN_DARK}\]\u\[$WHITE\]@\w\[$WHITE\]\$([[ -n \$(git branch 2> /dev/null) ]])\[$GREEN\]\$(parse_git_branch)\[$WHITE\] $(ruby_info) \[$GREEN_DARK\]→\[$WHITE\]\n\$  \[$RESET\]"

PS1="\n\033[G\[${BOLD}${GREEN_DARK}\]\u\[$WHITE\]@\w\[$WHITE\]\$([[ -n \$(git branch 2> /dev/null) ]])\[$GREEN\]\$(parse_git_branch) \[$GREEN_DARK\]→\[$WHITE\]\n\$  \[$RESET\]"

eval "$(rbenv init -)"

#### ALIAS --->
alias reload="source ~/.bash_profile"

alias bi='bundle install'
alias be='bundle exec ' # note the trailing space to trigger chaining
alias bu='bundle update '
alias brake='bundle exec rake '
alias gpull='git pull --rebase '
alias gst='git status'
alias gstash_logs='git fsck --unreachable | grep commit | cut -d" " -f3 | xargs git log --merges --no-walk --grep=WIP'
alias gem_uninstall='for i in `gem list --no-versions`; do gem uninstall -aIx $i; done'
