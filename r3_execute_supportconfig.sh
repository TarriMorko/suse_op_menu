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
    echo "supportconfig �w�p����ɶ��ݭn 1~10 �����C"
    echo "�ФŦh������"
    echo "�����ɦW�� nts_${file_prefix}.tgz"
    echo ''
    echo "�O�_�n�~�򦬶�(Y/N)�H"
    echo 'Do you want Use supportconfig to gather system configuration information?(Y/N)'
    read input
    if [[ "${input}" =~ [Yy]+ ]]; then
        return 0
    else
        exit 1
    fi
}

execute_supportconfig() {
    # supportconfig -g -R ${OUTPUT_DIR} -B "$(hostname)_$(date +%Y%m%d_%H%M%S)"
    if [ "${OUTPUT_DIR}" == "" ]; then
        echo "OUTPUT_DIR variable must be set."
        return 1
    fi

    writelog "Start supportconfig -g -R ${OUTPUT_DIR} -B ${file_prefix}"
    supportconfig -g -R ${OUTPUT_DIR} -B ${file_prefix}
    rc=$?
    chmod -R 775 ${OUTPUT_DIR}
    chmod 744 ${OUTPUT_DIR}/nts_${file_prefix}.tgz
    if [[ $rc -eq 0 ]]; then
        echo ''
        echo ''
        writelog "supportconfig �������\�A�ɮ׬� ${OUTPUT_DIR}/nts_${file_prefix}.tgz"
        echo "supportconfig done, output at  ${OUTPUT_DIR}/nts_${file_prefix}.tgz"
        echo ''
        echo ''
    else
        err "supportconfig ��������."
        echo "supportconfig fail."
    fi

}

remove_old_support_dir() {
    # remove *.bak, then rename *.tgz to *.bak
    for filename in ${OUTPUT_DIR}/*.tgz.bak; do
        rm $filename >/dev/null 2>&1 && writelog "�R�� $filename"
    done

    for filename in ${OUTPUT_DIR}/*.tgz; do
        mv "$filename" "${filename}.bak" >/dev/null 2>&1 && writelog "�N $filename ��W�� ${filename}.bak"
        rm ${OUTPUT_DIR}/*.md5 >/dev/null 2>&1
    done
}

main() {
    comfirm_and_show_warning
    remove_old_support_dir
    execute_supportconfig || return $to_adv_opmenu

}
main
