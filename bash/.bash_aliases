#!/usr/bin/env bash
#------------------------------------------------------------------------------
# File:   $HOME/.bash_aliases
# Author: Matt Burdan <burdz@burdz.net>
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# bash aliases
#------------------------------------------------------------------------------

# enable color support of ls and also add handy aliases
if [[ -x /usr/bin/dircolors ]]; then
    if test -r ~/.dircolors; then
        eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
        alias ls='ls --color=auto'
        alias dir='dir --color=auto'
        alias grep='grep --color=auto'
        alias ip='ip --color=auto'
    fi
fi

# some more ls aliases
alias ll='ls -larth'
alias la='ls -A'
alias l='ls -CF'

# even more aliasessss
alias c='clear'
alias mount='mount | column -t'
alias xclip="xclip -selection c"
alias fuck='sudo $(history -p !!)'
alias diskspace="du -S | sort -n -r |more"
alias ip-address='curl -s -H "Accept: application/json" https://ipinfo.io/json | jq "del(.loc, .postal)"'
alias diff='colordiff'
alias meminfo='free -m -l -t'

# batzz
alias bats="bat --plain"

# conky
alias conkyreset='killall -SIGUSR1 conky'
alias conkyrc='(vi ~/.conkyrc)'
alias killconky='killall conky'

# today
alias today='grep -h -d skip `date +%m/%d` /usr/share/calendar/*'

# open ports
alias openports='netstat -nape --inet'

# tree
alias tree='tree -CAhF --dirsfirst'
alias treeh='tree -CAhFa --dirsfirst'

# git stuff
alias ga='git add -A'
alias gs='git status'
alias gstat='git show --stat'
alias gb='git branch'
alias gba='git branch -a'
alias gl='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'
alias gc='git commit -S'
alias gca='git commit --amend'
alias gco='git checkout'
alias gprco='git pr checkout'
alias gprls='git pr list'
alias gd='git diff'
alias gdom='git diff origin/master'
alias grm='git rm `git ls-files --deleted`'
alias gpom='git remote prune origin'

# movement
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias cdroot="cd $(git rev-parse --show-toplevel)"

# sublime
alias st='subl .'

# hub alias
eval "$(hub alias -s)"

# firefox
alias firefox-temp='/opt/firefox/firefox --new-instance --profile $(mktemp -d)'

# kubes
alias k='kubectl'
alias k-set-namespace='kubectl config set-context $(kubectl config current-context) --namespace='
alias knodes='k get nodes --sort-by=.metadata.creationTimestamp'
alias kalias='complete -F __start_kubectl k'

# gotop
alias gotop='gotop -b -c solarized'

# watch
alias watcha='watch '

# fzf
alias xray='fzf --preview "bat --color=always {} 2> /dev/null"'

# wat no?
alias watnourxvt='echo export TERM=xterm-256color'
alias watnocolumns='stty rows 50 cols 400'

# present
alias gopresent='present -notes'

# vim
alias vimascii='vim -c "e ++enc=latin1"'

# urxvt
alias testurxvt='urxvt -pe'

# yaml/json
alias yaml2json="python -c 'import sys, yaml, json; json.dump(yaml.load(sys.stdin), sys.stdout, indent=2)'"
alias json2yaml="python -c 'import sys, yaml, json; yaml.safe_dump(json.load(sys.stdin), sys.stdout, default_flow_style=False)'"
