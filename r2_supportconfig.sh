#!/bin/bash
#
#
###############################################################################
# r2_supportconfig.sh
# Use supportconfig -R /src/support to gather system configuration information.
###############################################################################
# Globals variable :
#   OUTPUT_DIR              # Identifies the optional supportconfig command
#                                # output directory (/tmp/ibmsupt is the
#                                # default). You must specify the absolute path.
###############################################################################


OUTPUT_DIR="/source/supportconfig"
file_prefix="$(hostname)_$(date +%Y%m%d_%H%M%S)"

to_adv_opmenu="0"

ScriptName="r2_supportconfig.sh"
# Use supportconfig -R /src/support to ga"


remove_old_support_dir() {
  # remove *.bak, then rename *.tgz to *.bak
  if [ "${OUTPUT_DIR}" == "" ]; then
    echo "OUTPUT_DIR variable must be set."
    return 1
  else
    for filename in ${OUTPUT_DIR}/*.tgz.bak ; do
      rm $filename >/dev/null 2>&1
    done
    for filename in ${OUTPUT_DIR}/*.tgz ; do
      mv "$filename" "${filename}.bak" >/dev/null 2>&1
      rm ${OUTPUT_DIR}/*.md5
    done
  fi
}


execute_supportconfig() {
  # supportconfig -m -g -R ${OUTPUT_DIR} -B "$(hostname)_$(date +%Y%m%d_%H%M%S)"
  echo "supportconfig 預計執行時間需要 1~10 分鐘。"
  echo "請勿多次執行"
  echo "產生檔名為 nts_${file_prefix}.tgz"
  echo ''
  echo "是否要繼續收集(Y/N)？"
  echo 'Do you want Use supportconfig to gather system configuration information?(Y/N)'
  read input
  if [[ "${input}" = +([Yy]) ]] ; then
    remove_old_support_dir
    echo "Start supportconfig -m -g -R ${OUTPUT_DIR} -B ${file_prefix}"
    supportconfig -m -g -R ${OUTPUT_DIR} -B ${file_prefix}
    rc=$?
    chmod -R 775 ${OUTPUT_DIR}
    if [[ $rc -eq 0  ]]; then
      echo ''
      echo ''
      echo "supportconfig 收集成功，檔案為 ${OUTPUT_DIR}/nts_${file_prefix}.tgz"
      echo "supportconfig done, output at  ${OUTPUT_DIR}/nts_${file_prefix}.tgz"
      echo ''
      echo ''
    else
      echo "supportconfig 收集失敗."
      echo "supportconfig fail."
    fi
  else
    return 2
  fi
}


chmod_outputfile() {
  chmod -R 775 ${OUTPUT_DIR}
  chmod 744 ${OUTPUT_DIR}/nts_${file_prefix}.tgz
  if [[ $? -eq 0  ]]; then
    echo "Create ${OUTPUT_DIR}/nts_${file_prefix}.tgz ..."
  fi
}


transfer_outputfile_to_logserver() {
  # Use scp to transfer outputfile to a server.
  ${HAADMIN_HOME}/scp_to_file_server.sh ${OUTPUT_DIR}/nts_${file_prefix}.tgz
}


main() {
  execute_supportconfig || return $to_adv_opmenu
  chmod_outputfile
#   transfer_outputfile_to_logserver
}


if [[ "$(basename -- "$0")" == "${ScriptName}" ]]; then
  main
  exit 0
fi
