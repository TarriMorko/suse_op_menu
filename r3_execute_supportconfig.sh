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
    echo "supportconfig will takes about 15-20 minutes to produce th log files."
    echo "DO NOT execute twice."
    echo "Log file name is nts_${file_prefix}.tgz"
    echo ''
    echo "continue(Y/N)？"
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
        writelog "supportconfig done at ${OUTPUT_DIR}/nts_${file_prefix}.tgz"
        echo "supportconfig done, output at  ${OUTPUT_DIR}/nts_${file_prefix}.tgz"
        echo ''
        echo ''
    else
        err "supportconfig failed."
        echo "supportconfig failed."
    fi

}

remove_old_support_dir() {
    # remove *.bak, then rename *.tgz to *.bak
    for filename in ${OUTPUT_DIR}/*.tgz.bak; do
        rm $filename >/dev/null 2>&1 && writelog "DELETE $filename"
    done

    for filename in ${OUTPUT_DIR}/*.tgz; do
        mv "$filename" "${filename}.bak" >/dev/null 2>&1 && writelog "Move $filename to ${filename}.bak"
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
