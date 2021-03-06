# PS1
GIT_PROMPT_THEME=Solarized

if [ -f "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh" ]; then
    source "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh"
fi

# Aliases
alias cdl='cd /Users/asolanki/trp/logs'
alias cdp='cd /Users/asolanki/trp/git/puppet_legacy'
alias cdr='cd /Users/asolanki/trp/git/puppet_roles'
alias cdr10='cd /Users/asolanki/trp/git/r10k-code-control/'
alias cdc='cd /Users/asolanki/trp/git/puppet_core'
alias cdg='cd /Users/asolanki/trp/git'
alias cdt='cd /Users/asolanki/trp/git/trp-private'
alias cdgo='cd /Users/asolanki/trp/git/goldeneye'

alias ls='ls -rtFG'
alias ll='ls -lrtFG'
alias la='ls -lrtFG'

alias mvim='/usr/local/bin/mvim'
alias mvim='mvim --remote-silent-tab'
alias vi='mvim'
alias vim='mvim'

alias ppv='puppet parser validate'


alias gs='git status '
alias ga='git add '
alias gb='git branch '
alias gc='git commit -a -m'
alias gp='git push origin'
alias gd='git diff'
alias gcp='git checkout production'

alias kee="cat /Applications/KeePassX/pass.txt"
# Functions
function h() { if [ $1 == "--all" ]; then search='^f.*-'; domain=$2; else search='^f.{27,28}$'; domain=$1; fi; host -la ${domain}.fanops.net | awk -F" " '{print $1}' | sed -e 's/\.$//g' | egrep ${search} ;}
function alh() { if [ "$1" == "--all" ]; then arg=$1; fi; for x in fra1 ams2 iad1 iad2 las1 las2 lab1 lax2 sjc1 hkg1; do h ${arg} ${x} ; done ;}
