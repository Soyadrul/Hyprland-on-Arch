#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias gnome='XDG_SESSION_TYPE=wayland dbus-run-session gnome-session'
alias scan='sudo arp-scan --localnet'


# PS1 colors
Default_color="\[\e[00m\]"
Black="\[\e[30m\]"
Blue="\[\e[34m\]"
Light_Blue="\[\e[94m\]"
Cyan="\[\e[36m\]"
Light_Cyan="\[\e[96m\]"
Green="\[\e[32m\]"
Light_Green="\[\e[92m\]"
Magenta="\[\e[35m\]"
Light_Magenta="\[\e[95m\]"
Red="\[\e[31m\]"
Light_Red="\[\e[91m\]"
White="\[\e[37m\]"
Yellow="\[\e[33m\]"
Light_Yellow="\[\e[93m\]"

#PS1='[\u@\h \W]\$ '
PS1="${Light_Red}┌──${Light_Blue}󰣇${Light_Green} (\u@\h) [\w]\n${Light_Red}└─${Light_Yellow}\$${Default_color} "

if [[ -n "${SSH_TTY}" ]]; then
    PS1="${Red}┌──${Light_Blue}󰣇 ${Light_Green}[\u --> \w]${Default_color} (${Light_Cyan}SSH${Default_color})\n${Red}└─${Light_Yellow}#${Default_color} "
fi;

export HISTCONTROL=ignoredups
export HISTFILESIZE=100000
shopt -s histappend

export XDG_CONFIG_HOME=$HOME

neofetch --config $HOME/.config/neofetch/small.conf --ascii_distro arch_small




Execute_Prompt_Command=false

function prompt_command {
    history -a; history -n

    # Your custom command here
    if [[ "$Execute_Prompt_Command" = "true" ]]
    then
        echo -e ""
    else
        Execute_Prompt_Command=true
    fi
}

# Hook the function to the PROMPT_COMMAND variable
PROMPT_COMMAND=prompt_command
