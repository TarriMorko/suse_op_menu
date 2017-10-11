#!/bin/sh
#
#
###############################################################################
# mw_hc2.sh
# show a menu to check some system status
###############################################################################
# This script is main entry of advance opmenu.
#
# It contains the main menu for other sub function, and their default variable
# settings below. The "writelog" and "err" are exported for logging.
#
# Each sub fuciton script may not work without mw_hc2.sh, they must placed in
# the same folder with mw_hc2.sh.
#
# Read the manual.
###############################################################################

#### Scrtip Setting Start ####
SCRIPT_VERSION=1.0.0
export ScriptName="mw_hc2.sh"
export ROOT_DIR=$(dirname -- $0)
export OUTPUT_ROOT="/source"
export OUTPUT_DIR="${OUTPUT_ROOT}/supportconfig"
export LOGFILENAME="${ROOT_DIR}/mw_hc2.log"
export ERRFILENAME="${ROOT_DIR}/mw_hc2.err"
tmp=/tmp/mw_hc2.tmp

source ${ROOT_DIR}/writelog.sh

# Default variable for other script

# r3_supportconfig.sh
export file_prefix="$(hostname)_$(date +%Y%m%d_%H%M%S)"

# r4_check_FS_size.sh
export defualt_FileSystem="/source"
export SizeLowerLimit="2000"

# r5_show_cpu_usage.sh
export CPU_threshold="80"

# r6_show_mem_usage.sh
export mem_threshold="80"

# r7_show_io_usage.sh
export IO_threshold="80"

# r8_copy_to_file_server.sh
export CAT_OUTPUT_DIR="${OUTPUT_ROOT}/system_out"

#### Scrtip Setting END ####

show_main_menu() {
    # Just show main menu.
    clear
    cat <<EOF
  +====================================================================+
       Hostname: $(hostname), Today is $(date +%Y-%m-%d)
  +====================================================================+

    [R6]
      1. Check unsuccessful login count
      2. System Model
      3. Support Config
      4. Check FileSystem Size
      5. Show CPU usage
      6. Show Memory usage
      7. Show disk/IO usage
      8. Copy a file to TSM server
      
      q.QUIT

      Enter your choice, or press q to quit :

EOF
}

main() {
    # The entry for sub functions.
    cd ${ROOT_DIR}
    while true; do
        show_main_menu
        read choice
        clear
        case $choice in
        1) ./r1_check_unsuccessful_login_count.sh ;;
        2) ./r2_show_machine_serial.sh ;;
        3) ./r3_execute_supportconfig.sh ;;
        4) ./r4_check_FS_size.sh ;;
        5) ./r5_show_cpu_usage.sh ;;
        6) ./r6_show_mem_usage.sh ;;
        7) ./r7_show_io_usage.sh ;;
        8) ./r8_copy_to_file_server.sh ;;
        [Qq])
            echo ''
            echo 'Thanks !! bye bye ^-^ !!!'
            echo ''
            #logout
            exit
            logout
            ;;
        *)
            clear
            clear
            echo ''
            echo ' !!!  ERROR CHOICE , PRESS ENTER TO CONTINUE ... !!!'
            read choice
            ;;
        esac
        echo ''
        echo 'Press enter to continue' && read null
    done
}

if [[ "$(basename -- "$0")" == "${ScriptName}" ]]; then
    if [ ! -e "${LOGFILENAME}" ]; then
        touch ${LOGFILENAME}
    fi
    if [ ! -e "${ERRFILENAME}" ]; then
        touch ${ERRFILENAME}
    fi
    chown root ${LOGFILENAME}
    chmod 540 ${LOGFILENAME}
    chown root ${ERRFILENAME}
    chmod 540 ${ERRFILENAME}
    main
    exit 0
fi
