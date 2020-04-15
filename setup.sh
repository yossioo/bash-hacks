#!/bin/bash

source aliases.sh
printf "${LIGHT_BLUE_TXT}Installing BASH-Hacks${NC}.\n"

echo "## BASH-HACKS entries ##" >>~/.bashrc
echo "source ${PWD}/aliases.sh" >>~/.bashrc
echo "source ${PWD}/functions.sh" >>~/.bashrc
echo "## BASH-HACKS END ##" >>~/.bashrc

#if [[ -f ~/.inputrc ]];then
#	mv ~/.inputrc ~/.inputrc.bak
#fi
#ln -nsf ${PWD}/inputrc ~/.inputrc
