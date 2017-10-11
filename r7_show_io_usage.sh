#!/bin/bash
#
#
###############################################################################
# r7_show_io_usage.sh
# Show Top 3 usage of DISK/IO
###############################################################################

## For supportconfig
# OUTPUT_DIR="/source/supportconfig"
# file_prefix="$(hostname)_$(date +%Y%m%d_%H%M%S)"
# IO_threshold="80"

check_disk_usage() {
    # Displaying top disk_consuming processes.

    top_string=$(iotop -b -P -n 1 | awk 'NR==4')
    DISK_Highest_owner=$(echo $top_string | awk '{print $3}')
    DISK_Highest_process=$(echo $top_string | awk '{print $NF}')
    DISK_Highest_usage=$(echo $top_string | awk '{print $10}')
    DISK_Highest_PID=$(echo $top_string | awk '{print $1}')

    echo $top_string
    echo $DISK_Highest_usage
    echo ${DISK_Highest_usage%.*}
    echo ''
    echo ''
    echo "This DISK_Highest_usage user is"
    writelog "DISK �ϥβv�̰����ϥΪ̬O

    \" $DISK_Highest_owner \""
    echo ''
    echo ''
    writelog "PID �O $DISK_Highest_PID"

    return 0
}

collect_log_if_DISK_high() {
    if [ ${DISK_Highest_usage%.*} -ge $IO_threshold ]; then
        writelog "�гq���t�έȯZ�H���B�z�G��{ $DISK_Highest_process �� DISK �ϥβv�F�� $DISK_Highest_usage%"
        writelog "PID �O $DISK_Highest_PID"
        writelog "process: $DISK_Highest_process DISK high $DISK_Highest_usage%"
        writelog "PID is  $DISK_Highest_PID"
        $ROOT_DIR/r3_execute_supportconfig.sh
    fi
    return 0
}

main() {
    check_disk_usage
    collect_log_if_DISK_high
}
main
