#!/bin/sh
#
#
###############################################################################
# r8_copy_to_file_server.sh
# cat file setting
###############################################################################
# Globals variable :
#   CAT_OUTPUT_DIR
#   HAADMIN_HOME
###############################################################################

to_adv_opmenu="0"
readonly outputfile=$(hostname)_$(date +"%Y%m%d_%H%M%S")_r7.txt

check_filename_usability() {
    input_filename=$1
    if ! [[ "${input_filename}" =~ [0-9a-zA-Z._/]* ]]; then
        echo '�п�J���T�ɦW�C'
        echo 'filename error.'
        return 1
    fi

    if [ -d ${input_filename} ]; then
        echo '�����J�@�ӥؿ��C'
        echo 'Can not input a directory.'
        return 3
    fi

    if ! [ -r ${input_filename} ]; then
        echo '�䤣���ɮשεL�kŪ���C'
        echo 'File not found or can not read file.'
        return 4
    fi

    filesize=$(du -m $input_filename | cut -f1)
    if [ "${filesize}" -gt 10 ]; then
        echo '�ɮ׶W�L 10 MB�C'
        echo 'file too large'
        return 5
    fi
}

echo_file_contain_and_store_in_outputdir() {
    mkdir -p ${CAT_OUTPUT_DIR}
    chmod 755 ${CAT_OUTPUT_DIR}
    echo "${input_filename}" >${CAT_OUTPUT_DIR}/$outputfile
    writelog "�ɮ��x�s��:  ${CAT_OUTPUT_DIR}/$outputfile "
    cat "${input_filename}" | tee -a ${CAT_OUTPUT_DIR}/$outputfile
    chmod 774 ${CAT_OUTPUT_DIR}/$outputfile
}

transfer_outputfile_to_logserver() {
    $ROOT_DIR/scp_to_file_server.sh ${CAT_OUTPUT_DIR}/$outputfile
}

main() {
    clear
    find ${CAT_OUTPUT_DIR} -name "*_r7.txt" -exec rm {} \;
    echo "�п�J�Q�n�ǰe���ɮצW��:"
    echo 'Please enter which file you want to transer:'
    read input
    check_filename_usability $input || return $to_adv_opmenu
    echo_file_contain_and_store_in_outputdir
    transfer_outputfile_to_logserver
}
main
