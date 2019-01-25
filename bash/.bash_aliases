#------------------------------------------------------------------------------
# File:   $HOME/.bash_aliases
# Author: Matt Burdan <burdz@burdz.net>
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# bash aliases
#------------------------------------------------------------------------------

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias grep='grep --color=auto'
fi

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# even more aliasessss
alias xclip="xclip -selection c"
alias fuck='sudo $(history -p !!)'
alias diskspace="du -S | sort -n -r |more"

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

# sublime
alias st='subl .'

# hub alias
eval "$(hub alias -s)"

# firefox
alias firefox-temp='/opt/firefox/firefox --new-instance --profile $(mktemp -d)'

# kubes
alias k='kubectl'
alias k-set-namespace='kubectl config set-context $(kubectl config current-context) --namespace='
