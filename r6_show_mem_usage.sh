#!/bin/bash
#
#
###############################################################################
# r6_show_mem_usage.sh
# Show Top 3 usage of memory
###############################################################################

## For supportconfig
# OUTPUT_DIR="/source/supportconfig"
# file_prefix="$(hostname)_$(date +%Y%m%d_%H%M%S)"
# mem_threshold="80"

check_mem_usage() {
    # Displaying top mem_consuming processes.

    top_string=$(top -b -o +%MEM -n1 | awk 'NR==8')
    mem_Highest_owner=$(echo $top_string | awk '{print $2}')
    mem_Highest_process=$(echo $top_string | awk '{print $NF}')
    mem_Highest_usage=$(echo $top_string | awk '{print $(NF-2)}')
    mem_Highest_PID=$(echo $top_string | awk '{print $1}')

    echo ''
    echo ''
    echo "This Memory_Highest_usage user is"
    writelog "�O����ϥβv�̰����ϥΪ̬O

    \" $mem_Highest_owner \""
    echo ''
    echo ''
    echo "PID �O $mem_Highest_PID"

    return 0
}

collect_log_if_mem_high() {
    if [ ${mem_Highest_usage%.*} -ge $mem_threshold ]; then
        writelog "�гq���t�έȯZ�H���B�z�G��{ $mem_Highest_process �� �O���� �ϥβv�F�� $mem_Highest_usage%"
        writelog "PID �O $mem_Highest_PID"
        writelog "process: $mem_Highest_process mem high $mem_Highest_usage%"
        writelog "PID is  $mem_Highest_PID"
        $ROOT_DIR/r3_execute_supportconfig.sh
    fi
    return 0
}

main() {
    check_mem_usage
    collect_log_if_mem_high
}
main
