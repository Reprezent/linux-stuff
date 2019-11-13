source $HOME/.zsh/.zsh.path

# Sometimes I like to keep a history...
export SAVEHIST=2000
export HISTFILE=$HOME/.zsh/.zsh.history

export CVS_RSH=ssh

# Most people are ok with vim
export EDITOR=vim
export VISUAL=vim

# Set up the parameters for 'less' ... and use it
export LESS='-emiSRX'
export PAGER=less

umask 077

export PS1="\t \u@\h \n\w\\$ "
export TERM=$TERM
# Don't have the shell check for mail
unset MAIL         

## Printer Variables
if [[ "`/bin/uname -n`" == hydra* ]]; then
    export PRINTER="mk421"
fi  

## To set a specific printer as your default, comment
## out the following line and type in the name of the
## printer you want to set, e.g. mk355 or mk418.
#export PRINTER="mk###"

ulimit -c 0

autoload -U compinit
compinit
