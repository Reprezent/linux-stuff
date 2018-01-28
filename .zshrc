# Get other shell configuration
source $HOME/.zsh/.zshenv
source $HOME/.zsh/.zsh.prompt       # set the prompt
source $HOME/.zsh/.zsh.path         # setup the PATH
source $HOME/.zsh/.zsh.manpath      # setup the MANPATH
source $HOME/.zsh/.zsh.aliases  # setup command aliases

bindkey -d

export PATH="$PATH:/usr/local/gnuarm/bin"

# Set up printing
# uncomment the line below to set a default printer
# export PRINTER="mk###"

if [[ "`/bin/uname -n`" == hydra* ]]; then
    export PRINTER="hydra"
elif [[ "`/bin/uname -n`" == arc* ]]; then
    export PRINTER="arc"
fi  

# Turn off core dumps
limit coredumpsize 0

# Set some usefull options
setopt nohup            # Don't kill jobs when the shell exits
setopt nobeep           # Don't beep at me all the time
setopt nocheckjobs      # Don't check for running jobs at shell exit
setopt longlistjobs     # Show more information about jobs
setopt pushdtohome      # pushd goes to $HOME if nothing else is given
setopt noflowcontrol    # Disables ^S/^Q in line-edit mode


###### My Stuff #####################################

# wall Suppression
mesg n

# Adds scripts to Path search
export PATH="$PATH:~/scripts"

setopt AUTO_CD			# Automatically cds

function chpwd()
{
	emulate -L zsh
	ll
}

SSH_ENV="$HOME/.ssh/environment"

function add_keys
{
    keys=$(<"$HOME/.ssh/keys")
    for i in $(echo $keys | sed "s/$'\n'/ /g"); do
        /usr/bin/ssh-add "$HOME/.ssh/$i"
    done
}


function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    add_keys;
}

# Source SSH settings, if applicable

if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    #ps ${SSH_AGENT_PID} doesn't work under cywgin
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi
