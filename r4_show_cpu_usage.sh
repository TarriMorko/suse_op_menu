#!/bin/bash
#
#
###############################################################################
# r4_show_cpu_mem_usage.sh
# Show Top 3 usage of CPU
###############################################################################


WAS_Team_process="wasadmin"
DB2_Team_process=$(ps -ef| grep db2sys[c] | awk '{print $1}' | head -n 1)
MQ_Team_process=$WAS_Team_process' '$DB2_Team_process
SUPPORT_OUTPUT_DIR="/source/aixperf"
CPU_threshold="80"
MEM_threshold="80"


show_menu() {
  clear
  cat << EOF
    ***************** Check USAGE *********************

    1. CPU
    2. MEM
    3. DISK

    q. return to main menu

EOF
}


CPU_check() {
  # Displaying top CPU_consuming processes.
  echo '請稍待約 1 分鐘...'

  top_string=$(top -b -o +%CPU -n1 | awk 'NR==8')
  CPU_Highest_owner=$(echo $top_string  | awk '{print $2}')
  CPU_Highest_process=$(echo $top_string  | awk '{print $NF}')
  CPU_Highest_usage=$(echo $top_string  | awk '{print $(NF-3)}')
  CPU_Highest_PID=$(echo $top_string  | awk '{print $1}')
  
  echo ''
  echo ''
  echo "This CPU_Highest_usage user is"
  echo "CPU 使用率最高的使用者是\n

  \" $CPU_Highest_owner \""
  echo ''
  echo ''
  echo "PID 是 $CPU_Highest_PID"

  return 0
}


MEM_check() {
  # Displaying top 3 memory-consuming processes.
  ps aux | head -1; ps aux | sort -rn +3 | head -3
  MEM_Highest_usage=$(ps aux | sort -rn +3 | head -1 | awk '{print $4}')
  first_process=$(ps aux | sort -rn +3 | head -1 |awk '{print $1}')
  first_process_pid=$(ps aux | sort -rn +3 | head -1 |awk '{print $1}')
  echo ''
  echo "This MEM_Highest_usage user is"
  echo "記憶體使用量最高的使用者是 process is \n

  \" $first_process \""
  echo ''
  echo ''

  if [ ${MEM_Highest_usage%%.*} -ge 80 ]; then

    for process in ${MQ_Team_process}; do
      if [[ "${first_process}" == "${process}" ]]; then
        echo ''
        echo  "請通知 MQ 組值班人員：$first_process CPU 忙碌 $MEM_Highest_usage%"
        writelog "process: $first_process, cpu $MEM_Highest_usage%, please call MQ Team."
        echo ''
      fi
    done

    if [[ "${first_process}" == "${WAS_Team_process}" ]]; then
      # return 1 and aixperf
      return 1
    fi

    echo "請通知系統值班人員處理：$first_process CPU 忙碌 $MEM_Highest_usage%"
    writelog "process: $first_process, cpu $MEM_Highest_usage%"
  fi

  return 0
}


DISK_check() {
  # Displaying the process in order of I/O.
  topas -D
  return 0
}


exec_aixperf_then_scp_log_to_remote_server() {
  pid=$*
  echo 'aixperf 預計執行時間需要 5~10 分鐘。'
  echo '請勿多次執行'
  echo ''
  echo '是否要收集(Y/N)？'
  echo 'Do you want Use snap to gather system configuration information?(Y/N)'
  read input
  if ! [[ "${input}" = +([Yy]) ]] ; then
    return 2
  fi

  # remove *.bak, then rename *.tar to *.bak
  if [ "${SUPPORT_OUTPUT_DIR}" == "" ]; then
    writelog "SUPPORT_OUTPUT_DIR variable must be set."
    exit 1
  else
    echo "Clean up ${SUPPORT_OUTPUT_DIR}..."
    for filename in ${SUPPORT_OUTPUT_DIR}/*ixperf_RESULTS.tar.gz.bak ; do
      rm $filename 2>/dev/null && writelog "刪除 $filename " || writelog "無bak檔可刪除."
    done

    for filename in ${SUPPORT_OUTPUT_DIR}/*ixperf_RESULTS.tar.gz ; do
      mv "$filename" "${filename}.bak" 2>/dev/null && writelog "將 $filename 更名為 ${filename}.bak "
    done

    for filename in ${SUPPORT_OUTPUT_DIR}/*ixperf_RESULTS.tar ; do
      rm $filename 2>/dev/null && writelog "刪除 $filename "
    done
    
  fi

  echo "十秒後開始執行 aixperf."
  echo "run Aixperf..."
  sleep 10
  mkdir ${SUPPORT_OUTPUT_DIR}
  chmod 755 ${SUPPORT_OUTPUT_DIR}
  cd ${SUPPORT_OUTPUT_DIR}
  file_prefix=$(hostname)_$(date +%Y%m%d_%H%M%S)_OS
  $HAADMIN_HOME/aixperf.sh $pid
  writelog "aixperf.sh $pid"
  mv aixperf_RESULTS.tar.gz ${file_prefix}_aixperf_RESULTS.tar.gz
  if ! [[ $? -eq 0 ]] ; then
    writelog "aixperf.sh 未執行 gzip."
    gzip aixperf_RESULTS.tar
    mv aixperf_RESULTS.tar.gz ${file_prefix}_aixperf_RESULTS.tar.gz
  fi

  chmod 744 ${file_prefix}_aixperf_RESULTS.tar.gz
  cd $HAADMIN_HOME
  $HAADMIN_HOME/scp_to_file_server.sh ${SUPPORT_OUTPUT_DIR}/${file_prefix}_aixperf_RESULTS.tar.gz
  
}


main() {
  while true
  do
    show_menu
    read choice
    case "${choice}" in
      1)
        clear
        CPU_check || exec_aixperf_then_scp_log_to_remote_server $CPU_Highest_PID
        echo 'Press enter to continue'
        echo ''
        read null
      ;;
      2)
        clear
        MEM_check || exec_aixperf_then_scp_log_to_remote_server $MEM_Highest_PID
        echo 'Press enter to continue'
        echo ''
        read null
      ;;
      3)
        clear
        DISK_check
        echo 'Press enter to continue'
        echo ''
        read null
      ;;
      q)
        clear
        break
      ;;

      *)
        clear
      ;;
    esac
  done
}

main

