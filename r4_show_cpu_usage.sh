#!/bin/bash
#
#
###############################################################################
# r4_show_cpu_mem_usage.sh
# Show Top 3 usage of CPU
###############################################################################

source ./tools/execute_supportconfig.sh
if [ $? -ne 0 ]; then
    echo "Can not include ./tools/execute_supportconfig.sh"
    exit 1
fi

## For supportconfig
OUTPUT_DIR="/source/supportconfig"
file_prefix="$(hostname)_$(date +%Y%m%d_%H%M%S)"

ScriptName="r4_show_cpu_usage.sh"
WAS_process="wasadmin"
DB2_process=$(ps -ef| grep db2sys[c] | awk '{print $1}' | head -n 1)
MQ_Team_process=$WAS_process' '$DB2_process
CPU_threshold="80"


check_cpu_usage() {
    # Displaying top CPU_consuming processes.

    top_string=$(top -b -o +%CPU -n1 | awk 'NR==8')
    CPU_Highest_owner=$(echo $top_string  | awk '{print $2}')
    CPU_Highest_process=$(echo $top_string  | awk '{print $NF}')
    CPU_Highest_usage=$(echo $top_string  | awk '{print $(NF-3)}')
    CPU_Highest_PID=$(echo $top_string  | awk '{print $1}')
    
    echo ''
    echo ''
    echo "This CPU_Highest_usage user is"
    echo "CPU 使用率最高的使用者是

    \" $CPU_Highest_owner \""
    echo ''
    echo ''
    echo "PID 是 $CPU_Highest_PID"

    return 0
}

collect_log_if_CPU_high() {
  if [ ${CPU_Highest_usage%.*} -ge $CPU_threshold ]; then
      echo "請通知系統值班人員處理：行程 $CPU_Highest_process 的 CPU 使用率達到 $CPU_Highest_usage%"
      echo "PID 是 $CPU_Highest_PID"
      echo "process: $CPU_Highest_process cpu high $CPU_Highest_usage%"
      echo "PID is  $CPU_Highest_PID"
  fi
  remove_old_support_dir
  execute_supportconfig
  return 0
}  



main() {
    check_cpu_usage
    collect_log_if_CPU_high
 
}


if [[ "$(basename -- "$0")" == "${ScriptName}" ]]; then
    main
    exit 0
fi

