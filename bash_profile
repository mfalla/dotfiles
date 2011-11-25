function rvm_gemset_info() {
  gemset=$(rvm gemset name 2> /dev/null) || return
  if [[ $gemset != "/Library/Ruby/Gems/1.8" ]]; then
    echo "gemset($gemset) "
  fi
}

function parse_git_branch {
  branch=$(git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
  if [[ $branch != "" ]]; then
    echo "branch($branch) "
  fi
}

function get_ps1 {
  echo "$(whoami)@\W:\$(parse_git_branch)\$(rvm_gemset_info)→ "
}

PS1=$(get_ps1)

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function