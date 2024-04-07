#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'


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
#COMMAND_PROMPT="echo "ciao""


export HISTCONTROL=ignoredups
HISTFILESIZE=100000

neofetch --config $HOME/.config/neofetch/small.conf --ascii_distro arch_small
