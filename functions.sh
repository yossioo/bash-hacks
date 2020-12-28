#!/usr/bin/env bash
if [[ ${SKIP} == 1 ]]; then
    return 1
fi
#return 1

function wait-for-key-press() {
    echo "Press any key to continue"
    while [ true ] ; do
        read -t 1 -n 1
        if [ $? = 0 ] ; then
            exit ;
        else
            continue # echo "waiting for the keypress"
        fi
    done
    
}
function get-ip() {
    interface=${1:-""}
    silent=${2:-""}
    #got_ip=$(ifconfig ${interface} | sed -En 's/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
    got_ip=$(ifconfig ${interface} | sed -En 's/127.0.0.1//;s/172.17.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
    if [ -z "$silent" ]; then # If it is empty: add current field
        echo $got_ip
    fi
}

function kill-tmux-gz() {
    tmux kill-session -t test
    kg
}

function mount-image() {
    image=${1:-""}
    if [[ -z "${image}" ]]; then
        printf "${RED_TXT}Image file not specified.${NC}\n"
    else
        printf "Mounting ${LIGHT_BLUE_TXT}$image ${NC}.\n"
        dirname=${image}.d
        mkdir $dirname
        sudo mount -o loop $image $dirname
        # echo $lstring >$LAUNCH_FILE
    fi
}

function set-test-launch() {
    lstring=${1:-""}
    if [[ -z "${lstring}" ]]; then
        printf "${RED_TXT}ROS launch file not specified.${NC}\n"
    else
        printf "Saving the launch ${LIGHT_BLUE_TXT}$lstring${NC} for tests.\n"
        echo $lstring >$LAUNCH_FILE
    fi
}

function get-test-launch() {
    curr_test_launch=$(cat $LAUNCH_FILE)
}

function test-launch() {
    get-test-launch
    printf "Launching ${LIGHT_BLUE_TXT}$curr_test_launch${NC}\n"
    tmux new -s test -d "${curr_test_launch}"
}

function s() {
    lt=${1:-100}
    usr=${2:-nvidia}
    ssh_host="${usr}@192.168.131.${lt}"
    printf "${BLUE_TXT}Initiating ssh connection to ${ssh_host}.${NC}\n"
    ssh ${ssh_host}
}

function mountTX() {
    bird_num=${1:-""}
    if [[ -z "${bird_num}" ]]; then
        printf "${RED_TXT}Bird number not specified.${NC}\n"
    else
        printf "${BLUE_TXT}Specified bird number: ${bird_num}.${NC}\n"
        cmd="sshfs nvidia@10.0.0.${bird_num}:/home/nvidia /home/${USER}/TX"
        printf "Executing: ${cmd}\n"
        ${cmd}
    fi
}
function unmountTX() {
    sudo umount /home/yossi/TX
}

# QuickEdit files
QE_EDITOR="atom "
QE_FILES_LIST="/home/yossi/Dropbox/zis_iz_backup/qt-files.txt"
function qe-file() {
    get_files_list
    ask_for_num $cnt
    for i in "${fs_arrIN[@]}"; do
        c=$(($c + 1))
        if [[ $c == $num ]]; then
            $QE_EDITOR $i
        fi
    done
    
}

function get_files_list() {
    fs=$(cat ${QE_FILES_LIST})
    fs_arrIN=(${fs// / })
    printf "${GREEN_TXT}QuickEdit files in ~${QE_FILES_LIST}${NC}\n"
    
    # Search for longest ws name
    max_l=0
    for i in "${fs_arrIN[@]}"; do
        l=$(expr length "$i")
        # echo $(($l)), $(($max_l))
        if [[ $(($l)) -gt $(($max_l)) ]]; then
            # echo "New line is longer"
            max_l=$(($l))
        fi
    done
    pad=""
    c=$(($max_l + 2))
    while [[ $c > 0 ]]; do
        pad="$pad-"
        c=$((c - 1))
    done
    cnt=0
    printf "|%-5s|%-$(echo $max_l)s|\n" "-----" "$pad"
    printf "| %-3s | %-$(echo $max_l)s |\n" "NUM" "FILE NAME"
    printf "|%-5s|%-$(echo $max_l)s|\n" "-----" "$pad"
    for i in "${fs_arrIN[@]}"; do
        cnt=$(($cnt + 1))
        printf "| ${NC}%-3s${NC} | ${WHITE_TXT}%-$(echo $max_l)s${NC} |\n" "$cnt" "$i"
    done
    printf "|%-5s|%-$(echo $max_l)s|\n" "-----" "$pad"
    
}
function ask_for_num() {
    max=${1:-"1"}
    if [[ $(($max)) -lt 10 ]]; then
        read -n 1 -p "Select a number of file to edit [1-$max] or cancel : " num
    else
        read -n 2 -p "Select a number of file to edit [1-$max] or cancel : " num
    fi
    case $num in
        [123456789]*)
            echo ""
            # echo "Sourcing WS #$num"
        ;;
        # [Cc]*)
        #   echo ""
        #   return 1
        #   ;;
        *)
            echo ""
            echo "Cancelling."
        ;;
    esac
}

# Function sets rosmster. Either specify last byte for Mobilicom pool, or specify full ip and second argumen 1
function RM() {
    ip=${1:-100}
    full_ip=${2:-0}
    if [ ${full_ip} != 1 ]; then
        ip="192.168.131.${ip}"
    fi
    arg="ROS_MASTER_URI=http://${ip}:11311"
    printf "Setting environment variable: ${arg}\n"
    export ${arg}
}



function upd_desktop_shortcuts() {
    ln -nsf ~/Dropbox/zis_iz_backup/DesktopLinks/*.desktop ~/Desktop/
    ln -nsf ~/.local/share/applications/jetbrains-clion.desktop ~/Desktop/
}

function udp() {
    address=${1:-0}
    port=${2:-0}
    msg=${3:-0}
    if [ ${address} == 0 ]; then
        exit 1
    fi
    if [ ${port} == 0 ]; then
        exit 1
    fi
    if [ ${msg} == 0 ]; then
        msg="Empty string"
    fi
    echo "Sending message to ${address}:${port} with contents [${msg}]"
    echo -n ${msg} >/dev/udp/${address}/${port}
}

function mcd() {
    dirname=${1:-0}
    if [ ${dirname} == 0 ]; then
        echo "No folder specified."
    else
        mkdir -p ${dirname}
        cd ${dirname}
    fi
}

function t() {
    text=${1:-0}
    if [ ${text} == 0 ]; then
        printf "No text pattern specified.\nUsage: ${BLUE_TXT}t <pattern>${NC} := ${BLUE_TXT}grep -r <pattern> ./${NC} \n"
    else
        grep -r "${text}" ./
    fi
}

function size() {
    dirname=${1:-"*"}
    du -hs ${dirname}
}
# function d() {
#   directory=${1:-""}
#   du -h --max-depth=1 ${directory}
#   du -sh * # Another mode
# }
function tm() {
    # Use iteration to eliminate quotes need:
    # { printf '"%s" ' "$@"; echo ""; }
    cmd=${1:-""}
    if [[ -z "${cmd}" ]]; then
        printf "${RED_TXT}No command specified.${NC}\n"
        printf "Usage:\ntm 'kate tempfile.txt'\n"
    else
        tmux new -d "${cmd}"
    fi
}

function tcp_listen() {
    echo $(lsof -n -i4TCP:$1 | grep LISTEN)
}

function whosaround() {
    ips=$(get-ip | grep -oP "(\d{1,3}\.\d{1,3}\.\d{1,3}.\d{1,3})" | sort -u)
    printf "Found IP addresses: ${WHITE_TXT}"
    echo $ips
    printf "${NC}\n"
    ips=$(get-ip | grep -oP "(\d{1,3}\.\d{1,3}\.\d{1,3})" | sort -u)
    arrIN=(${ips// / })
    for i in "${arrIN[@]}"; do
        range=${i}.0/24
        printf "${LIGHT_BLUE_TXT}\nScanning range: $range.${NC}\n"
        nmap -sn $range
    done
}

function h() {
    str=${1:-""}
    if [[ -z "${str}" ]]; then
        history
    else
        history | grep -i ${str}
    fi
}

function process_info() {
    PID=${1:-""}
    if [[ ! -z "${PID}" ]]; then
        ps -p ${PID} ww
    else
        printf "No process ID specified.\n"
    fi
}

function pinfo(){
    name=${1:-""}
    if [[ ! -z "${name}" ]]; then
        ps -ef | grep ${name}
    else
        printf "No process name specified.\n"
    fi
}

function my_info() {
    # Displays help hints
    printf "\n${LIGHT_BLUE_TXT}Information:${NC}\n"
    echo "check aliases by typing 'alias'"
    echo "Implemented functions:"
    printf "${WHITE_TXT}s XXX${NC}: connects by ssh to host 192.168.131.XXX\n"
    printf "${WHITE_TXT}RM XXX${NC}: sets ROS_MASTER_URI environment variable to point to: http://192.168.131.XXX:11311\n"
    printf "${WHITE_TXT}RM XXX 1${NC}: sets ROS_MASTER_URI environment variable to point to: http://XXX:11311\n"
    printf "${WHITE_TXT}get-ip XXX${NC}: sets 'got-ip' variable to include ip addtess for network interface XXX\n\t\tIf no arguments specified, returns all but localhost.\n"
    printf "${WHITE_TXT}fixJB${NC}: Updates the shortcuts for JetBrains projects to be compatible with ROS.\n"
    get_ip
}

preexec() {
    cmd_start="$SECONDS"
}

precmd() {
    local cmd_end="$SECONDS"
    elapsed=$((cmd_end - cmd_start))
    print "Elapsed: ${elapsed}"
    # PS1="$elapsed "
}
