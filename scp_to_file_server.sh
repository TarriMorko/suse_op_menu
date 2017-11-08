#!/bin/sh
#
#
###############################################################################
# scp_to_file_server.sh
# for file transfer
###############################################################################
# example:
#
#  ./scp_to_file_server.sh FILE
#
#  then the FILE will copy to remote server

full_filename=$1
filename=${full_filename##*/}
to_adv_opmenu="0"
source $(dirname -- $0)/writelog.sh

# scp_to_file_server.sh, to tsmbk
user=opusr
# target=10.0.23.141
target=192.168.142.111
target_root_directory="/source/opuse/"
target_directory=${target_root_directory}$(hostname)_$(date +%Y%m%d)

# scp_to_file_server.sh, to tsmP ,for backup
copy_to_tsm_prod="False" # True / False
user_tsmp=opusr
target_tsmp=10.0.23.133
target_root_directory="/source/opuse/"
target_directory_tsmp=${target_root_directory}$(hostname)_$(date +%Y%m%d)

check_log_server_ssh_connection() {
    # Check remote server connection
    writelog "Connecting to $target... "
    su opusr -c "ssh $user@$target hostname >/dev/null 2>&1"
    rc=$?
    if [ $rc == "0" ]; then
        writelog 'ssh ���\�s�u��' "$target."
        writelog "ssh connect to $target success."
        echo ''
        return 0
    else
        err '�s�u��' "$target" '����'
        err "ssh connect to $target fail."
        echo ''
        return 1
    fi
}

make_remote_directory_and_transfer_file_to_log_server() {
    echo ''
    echo ''
    echo ''
    su opusr -c "ssh $user@$target mkdir -p $target_directory" || writelog "�b $target �إ� $target_directory ����"
    su opusr -c "ssh $user@$target chmod 755 $target_directory"
    writelog '�ǳƶǰe�ɮ�, �еy��...'
    writelog "prepare to transfer file..."
    echo ''

    su opusr -c "scp $full_filename $user@$target:$target_directory"
    #su opusr -c "scp $full_filename $user@$target:$target_directory"
    if [[ $? -eq 0 ]]; then
        writelog "File transfer success, please download at host $target : $target_directory/$filename"
        su opusr -c "ssh $user@$target chmod 744 $target_directory/$filename"
        echo ''
        writelog "�ɮ׶ǰe���\, �Цb $target �D���U�� $target_directory/$filename"
        echo ''
        echo '- - - - - - - - - - - - - - - - - - - - - - -'
        echo '�б���U���B�J�G'
        echo '- - - - - - - - - - - - - - - - - - - - - - -'
        echo '�ж}�� filezilla'
        echo '�D��'"�G sftp://${target}"
        echo '�ϥΪ̦W�١Gopusr'
        echo '�K�X�G <�d��>'
        echo '�s����G22'
        echo '���ֳt�s�u'
        echo '���ݯ��x�G' "$target_directory"
        echo '��Enter'
        echo '�ɮצW�١G' "$filename"
        echo '�I�惡�ɩԨ쥪����A�Y�U�������C'
        return 0
    else
        err "�ɮ׶ǰe�� $target ����."
        err "File tranfer to $target fail."
        return 1
    fi

    su opusr -c "ssh $user@$target chmod 755 $target_directory/$filename"
    su opusr -c "ssh $user@$target chmod 755 $target_directory"
    su opusr -c "ssh $user@$target chmod 755 ${target_root_directory}"
}

slient_copy_to_tsm_prod() {
    # ugly
    # user_tsmp=opusr
    # target_tsmp=fxdb2t
    writelog "�ǰe�ɮצ� $target_tsmp"
    target_directory_tsmp=${target_root_directory}$(hostname)_$(date +%Y%m%d)
    su opusr -c "ssh $user_tsmp@$target_tsmp mkdir -p $target_directory_tsmp"
    su opusr -c "ssh $user_tsmp@$target_tsmp chmod 755 $target_directory_tsmp"
    su opusr -c "scp $full_filename $user_tsmp@$target_tsmp:$target_directory_tsmp" && writelog "copy to $target_tsmp success."
    su opusr -c "ssh $user_tsmp@$target_tsmp chmod 755 $target_directory_tsmp/$filename"
    su opusr -c "ssh $user_tsmp@$target_tsmp chmod 755 $target_directory_tsmp"
    su opusr -c "ssh $user_tsmp@$target_tsmp chmod 755 ${target_root_directory}"
}

main() {
    check_log_server_ssh_connection || exit 1
    make_remote_directory_and_transfer_file_to_log_server
    if [ $copy_to_tsm_prod = "True" ]; then
        slient_copy_to_tsm_prod
    fi
}

main
