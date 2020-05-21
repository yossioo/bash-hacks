#!/usr/bin/env bash
if [[ ${SKIP} == 1 ]]; then
  return 1
fi
#return 1

DEF_CAT=1

# Define colors:
GREEN_TXT='\e[0;32m'
GREEN_TXT2='\e[32m'
DARK_GREEN_TXT='\e[2;32m'
WHITE_TXT='\e[1;37m'
RED_TXT='\e[31m'
DIM_RED_TXT='\e[2;31m'
LIGHT_BLUE_TXT='\e[96m'
BLUE_TXT='\e[34m'
DIM_BLUE_TXT='\e[2;34m'
DARK_GREY_TXT='\e[90m'
YELLOW_TXT='\e[93m'
NC='\033[0m'


ROS1_NAME='melodic'
ROS2_NAME='dashing'


WS_FILE=$HOME/.ros_ws_selected
LAUNCH_FILE=$HOME/.latest_launch


# Define aliases:
#alias my_ip="ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'"
#alias sab='source /home/yossi/angry_ws/src/angry_birds_ros/angry_birds_ros/aliases.bash; source /home/yossi/angry_ws/devel/setup.bash'
#alias umc='unalias mc'
#alias test_vision='roslaunch angry_vision test.launch'

alias cac='catkin config --cmake-args -DCMAKE_BUILD_TYPE=Release'

alias whgit='git config --get remote.origin.url'
alias e='nano '
alias mm='sudo chown -R $USER:$USER'
alias x='chmod +x '
alias o='sudo chown $USER:$USER '
alias mke='make -j`nproc`'

# Gstreamer and FFmpeg
alias fff='ffmpeg -f v4l2 -list_formats all -i '

# Aliases for system management and administration
alias rsync='rsync -a -v -h --progress'
alias r='rsync -a -v -h --progress'
alias midc='/usr/bin/mc'
alias saud='sudo apt update; alu'
alias saug='sudo apt upgrade'
alias saar='sudo apt autoremove'
alias alu='apt list --upgradable'
alias l='ls  --color=auto -lh --group-directories-first'
alias ll='ls --color=auto -lhaF --group-directories-first'
alias fkc='echo 0 | sudo tee /sys/module/hid_apple/parameters/fnmode'
alias p='ping -vc4'
alias df='df -h -x squashfs -x tmpfs -x devtmpfs'
alias '?'='xwininfo'
alias c='clear'
alias d='xdg-open '
alias ..='cd ..'
alias nedal='nano ~/Dropbox/zis_iz_backup/my_aliases.sh'
alias edal='atom ~/Dropbox/zis_iz_backup/my_aliases.sh'
alias edf='atom ~/Dropbox/zis_iz_backup/my_bash_functions.sh'
alias kedal='tmux new -s kedal -d "kate ~/Dropbox/zis_iz_backup/my_aliases.sh"'
alias whR='nmap -sn 10.0.0.0/24'
alias whG='nmap -sn 192.168.131.0/24'
alias wapt='ps aux | grep -i apt'
#alias upd_desktop_shortcuts='ln -nsf ~/Dropbox/zis_iz_backup/DesktopLinks/*.desktop ~/Desktop/;'
alias upd_dash_shortcuts='ln -nsf ~/Dropbox/zis_iz_backup/DesktopLinks/*.desktop ~/.local/share/applications/'

# Tmux aliases:
alias ktmuxa='until tmux '

alias wnv="watch -n 0.2 'lsusb  |  grep -i nvidia'"
# alias wnv="watch -n 0.2 'DV=$(lsusb  |  grep -i nvidia); if [ -z $DV ]; then printf \"No NVidia device found.\n\"; else printf \"Found: $DV\n\"; fi'"
# alias wnv="watch -n 0.2 'DV=$(lsusb  |  grep -i nvidia); if [ -z $DV ]; then printf \"nothing\"; else printf  \"$DV\"; fi'"
# alias wnv="watch -n 0.2 'DV=$(lsusb  |  grep -i nvidia); printf $DV'"
alias sb='source ~/.bashrc'
alias tso='xset dpms force off'
#alias p="php -r 'echo \"Your PHP installation is working fine.\n\";'"
alias sa='export PATH="/home/yossi/Apps/anaconda3/bin:$PATH"'
alias kp='killall plasmashell; kstart plasmashell; exit'
#alias wv='ls /dev/video*'
alias pg='ping 8.8.8.8'
alias srw='sudo grub-reboot 2 && reboot'
#alias start_postgress="/usr/lib/postgresql/10/bin/pg_ctl -D /var/lib/postgresql/10/main -l logfile start"
#alias start_postgress="/usr/lib/postgresql/9.5/bin/pg_ctl -D /var/lib/postgresql/9.5/main -l logfile start"
#
export EDITOR='nano -w'

# Logout after X seconds
#export TMOUT=$((60 * 60))

# Setup the bash prompt depending on the distro:
# Read more on: https://www.booleanworld.com/customizing-coloring-bash-prompt/
if [[ $(lsb_release -cs) == 'xenial' ]]; then
  PS1='$(if [[ $? == 0 ]]; then echo "\[\e[32m\]okay"; else echo "\[\e[31m\]fail"; fi) \[\033[01;49;92m\]\u\[\033[00;49;92m\]@\h\[\033[00m\] \[\033[03;94m\]\w\[\033[00m\]\[\033[38;5;51m\]$(__git_ps1)\[\033[00m\]:\n\$ '
elif [[ $(lsb_release -cs) == 'bionic' ]]; then
  PS1='$(if [[ $? == 0 ]]; then echo "\[\033[01;49;92m\]\u@\h\[\033[00m\]"; else echo "\[\e[31m\]FAIL @\h\[\033[00m\]"; fi) \[\033[03;94m\]\w\[\033[00m\]\[\033[38;5;51m\]$(__git_ps1)\[\033[00m\]:\n\$ '
  # PS1='$(if [[ $? == 0 ]]; then echo "\[\e[32m\]✅"; else echo "\[\e[31m\]❌"; fi) \[\033[01;49;92m\]\u\[\033[00;49;92m\]🤖\h\[\033[00m\] \[\033[03;94m\]\w\[\033[00m\]\[\033[38;5;51m\]$(__git_ps1)\[\033[00m\]:\n└─➡ \$ '
fi

# # History tweaks
shopt -s histappend
shopt -s cmdhist
#export PROMPT_COMMAND='history -a'
export HISTFILESIZE=5000000000 #-1
export HISTSIZE=5000000 # -1
export HISTCONTROL=ignoredups:erasedups # ignoreboth
export HISTIGNORE='l:ls:bg:fg:history:kp'
export HISTTIMEFORMAT="[$(tput setaf 6)%F %T$(tput sgr0)]: " # colorful date
# export HISTTIMEFORMAT='%F %T '

