# System-wide .bashrc file for interactive bash(1) shells.

# Make bash check its window size after a process completes
shopt -s checkwinsize
# Tell the terminal about the working directory at each prompt.
if [ "$TERM_PROGRAM" == "Apple_Terminal" ] && [ -z "$INSIDE_EMACS" ]; then
    update_terminal_cwd() {
        # Identify the directory using a "file:" scheme URL,
        # including the host name to disambiguate local vs.
        # remote connections. Percent-escape spaces.
	local SEARCH=' '
	local REPLACE='%20'
	local PWD_URL="file://$HOSTNAME${PWD//$SEARCH/$REPLACE}"
	printf '\e]7;%s\a' "$PWD_URL"
    }
    PROMPT_COMMAND="update_terminal_cwd; $PROMPT_COMMAND"
fi



if [ $(id -u) -eq 0 ];
then # you are root, set red colour prompt
  export MYPS='$(echo -n "${PWD/#$HOME/~}" | awk -F "/" '"'"'{
  if (length($0) > 14) { if (NF>4) print $1 "/" $2 "/.../" $(NF-1) "/" $NF;
  else if (NF>3) print $1 "/" $2 "/.../" $NF;
  else print $1 "/.../" $NF; }
  else print $0;}'"'"')'
  PS1='\[\e[1;31m\]$(eval "echo ${MYPS}")\[\e[m\] \[\e[0;31m\]#\[\e[m\] '
else # normal
  export MYPS='$(echo -n "${PWD/#$HOME/~}" | awk -F "/" '"'"'{
  if (length($0) > 14) { if (NF>4) print $1 "/" $2 "/.../" $(NF-1) "/" $NF;
  else if (NF>3) print $1 "/" $2 "/.../" $NF;
  else print $1 "/.../" $NF; }
  else print $0;}'"'"')'
  PS1='\[\e[1;33m\]$(eval "echo ${MYPS}")\[\e[m\] \[\e[1;32m\]\$\[\e[m\] '
fi




function h() { if [ $1 == "--all" ]; then search='^f.*-'; domain=$2; else search='^f.{27,28}$'; domain=$1; fi; host -la ${domain}.fanops.net | awk -F" " '{print $1}' | sed -e 's/\.$//g' | egrep ${search} ;}

function alh() { if [ "$1" == "--all" ]; then arg=$1; fi; for x in fra1 ams2 iad1 las1 las2 lab1 lax2 sjc1 nrt1 hkg1; do h ${arg} ${x} ; done ;}

export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

alias vi='/usr/local/Cellar/macvim/7.4-74/bin/gvim --remote-tab-silent'
alias vim='/usr/local/Cellar/macvim/7.4-74/bin/gvim --remote-tab-silent'
alias mvim='/usr/local/Cellar/macvim/7.4-74/bin/gvim --remote-tab-sient'

alias ll='ls -lrt'
alias la='ls -a'

alias cdp='cd /Users/asolanki/trp/git/puppet_production/'
alias cdpm='cd /Users/asolanki/trp/git/puppet_production/modules'

if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH"
fi

# MacPorts Installer addition on 2015-07-26_at_16:14:39: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

