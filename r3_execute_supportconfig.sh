#!/bin/bash
#
#
###############################################################################
# execute_supportconfig.sh 
# Use supportconfig -R /src/support to gather system configuration information.
###############################################################################
# Globals variable :
#   OUTPUT_DIR              # Identifies the optional supportconfig command
#                                # output directory (/tmp/ibmsupt is the
#                                # default). You must specify the absolute path.
###############################################################################

comfirm_and_show_warning() {
    echo "supportconfig 預計執行時間需要 1~10 分鐘。"
    echo "請勿多次執行"
    echo "產生檔名為 nts_${file_prefix}.tgz"
    echo ''
    echo "是否要繼續收集(Y/N)？"
    echo 'Do you want Use supportconfig to gather system configuration information?(Y/N)'
    read input
    if [[ "${input}" =~ [Yy]+ ]]; then
        return 0
    else
        exit 1
    fi
}

execute_supportconfig() {
    # supportconfig -m -g -R ${OUTPUT_DIR} -B "$(hostname)_$(date +%Y%m%d_%H%M%S)"
    if [ "${OUTPUT_DIR}" == "" ]; then
        echo "OUTPUT_DIR variable must be set."
        return 1
    fi

    writelog "Start supportconfig -m -g -R ${OUTPUT_DIR} -B ${file_prefix}"
    supportconfig -m -g -R ${OUTPUT_DIR} -B ${file_prefix}
    rc=$?
    chmod -R 775 ${OUTPUT_DIR}
    chmod 744 ${OUTPUT_DIR}/nts_${file_prefix}.tgz
    if [[ $rc -eq 0 ]]; then
        echo ''
        echo ''
        writelog "supportconfig 收集成功，檔案為 ${OUTPUT_DIR}/nts_${file_prefix}.tgz"
        echo "supportconfig done, output at  ${OUTPUT_DIR}/nts_${file_prefix}.tgz"
        echo ''
        echo ''
    else
        err "supportconfig 收集失敗."
        echo "supportconfig fail."
    fi

}

remove_old_support_dir() {
    # remove *.bak, then rename *.tgz to *.bak
    for filename in ${OUTPUT_DIR}/*.tgz.bak; do
        rm $filename >/dev/null 2>&1 && writelog "刪除 $filename"
    done

    for filename in ${OUTPUT_DIR}/*.tgz; do
        mv "$filename" "${filename}.bak" >/dev/null 2>&1 && writelog "將 $filename 更名為 ${filename}.bak"
        rm ${OUTPUT_DIR}/*.md5 >/dev/null 2>&1
    done
}

main() {
    comfirm_and_show_warning
    remove_old_support_dir
    execute_supportconfig || return $to_adv_opmenu
    $ROOT_DIR/scp_to_file_server.sh ${OUTPUT_DIR}/nts_${file_prefix}.tgz

}
main
