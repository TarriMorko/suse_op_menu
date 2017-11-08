#!/bin/bash
#
#
###############################################################################
# r5_show_cpu_usage.sh
# Show Top 3 usage of CPU
###############################################################################

## For supportconfig
# OUTPUT_DIR="/source/supportconfig"
# file_prefix="$(hostname)_$(date +%Y%m%d_%H%M%S)"
# CPU_threshold="80"

check_cpu_usage() {
    # Displaying top CPU_consuming processes.

    top_string=$(top -bn1 | awk 'NR==8')
    CPU_Highest_owner=$(echo $top_string | awk '{print $2}')
    CPU_Highest_process=$(echo $top_string | awk '{print $NF}')
    CPU_Highest_usage=$(echo $top_string | awk '{print $(NF-3)}')
    CPU_Highest_PID=$(echo $top_string | awk '{print $1}')

    echo ''
    echo ''
    echo "This CPU_Highest_usage user is"
    writelog "CPU 使用率最高的使用者是

    \" $CPU_Highest_owner \""
    echo ''
    echo ''
    writelog "PID 是 $CPU_Highest_PID"

    return 0
}

collect_log_if_CPU_high() {
    if [ ${CPU_Highest_usage%.*} -ge $CPU_threshold ]; then
        writelog "請通知系統值班人員處理：行程 $CPU_Highest_process 的 CPU 使用率達到 $CPU_Highest_usage%"
        writelog "PID 是 $CPU_Highest_PID"
        writelog "process: $CPU_Highest_process cpu high $CPU_Highest_usage%"
        writelog "PID is  $CPU_Highest_PID"
        $ROOT_DIR/r3_execute_supportconfig.sh
    fi
    return 0
}

main() {
    check_cpu_usage
    collect_log_if_CPU_high
}
main
