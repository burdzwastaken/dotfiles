c_red=$(tput setaf 1)
c_green=$(tput setaf 2)
c_sgr0=$(tput sgr0)
# cyan=$(tput setaf 6)

parse_git_branch ()
{
  if git rev-parse --git-dir >/dev/null 2>&1
  then
    gitver=$(git branch 2>/dev/null| sed -n '/^\*/s/^\* //p')
  else
    return 0
  fi
  echo -e "$gitver"
}

branch_color ()
{
  if git rev-parse --git-dir >/dev/null 2>&1
  then
    color=""
    #if git diff --quiet 2>/dev/null >&2
    if git status | grep "nothing to commit" >/dev/null 2>&1
    then
      color="${c_green}"
    else
      color=${c_red}
    fi
  else
    return 0
  fi
  echo -ne "$color"
}

PS1='[\[$(branch_color)\]$(parse_git_branch)\[${c_sgr0}\]] \u@\[${c_red}\]\w\[${c_sgr0}\]: '
#PS1='[\[$(branch_color)\]$(parse_git_branch)\[${c_sgr0}\]] \u@\h\[${c_red}\]\w\[${c_sgr0}\]: '
