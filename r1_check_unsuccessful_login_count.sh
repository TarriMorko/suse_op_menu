#!/bin/bash
#
#
###############################################################################
# r1_check_unsuccessful_login_count.sh
# show unsuccessful_login_count with specify user.
###############################################################################

to_adv_opmenu="0"

check_ID_usability() {
    user_name=$1
    if [[ "${user_name}" =~ [qQ] ]]; then
        echo '���}�B�^����C'
        return 2
    fi

    if [[ "${user_name}" = "" ]]; then
        echo '�п�J�b���W�١C'
        return 1
    fi

    if [[ "${user_name}" =~ " " ]]; then
        echo '�п�J�b���W�١C'
        return 1
    fi

    id $user_name >/dev/null 2>&1

    if ! [[ $? -eq 0 ]]; then
        echo '�b�����~�B�п�J���T�b���W�١C'
        return 1
    fi
}

show_unsuccessful_login_count() {
    unsuccessful_login_count=$(pam_tally2 -u $user_name |
        tail -n 1 | awk '{print $2}')
    if [[ "${unsuccessful_login_count}" = "" ]]; then
        err '�L�k���o unsuccessful_login_count'
        return 1
    fi

    if [ ${unsuccessful_login_count} -gt 5 ]; then
        writelog "�b�� $user_name �n�J�K�X���~ $unsuccessful_login_count ���A�b���w�Q��w�C�бb���֦��̬���ެ����C"
    else
        writelog "�b�� $user_name �n�J�K�X���~ $unsuccessful_login_count ��"
    fi
}

show_host_last_login() {
    lastlog --user $user_name
}

main() {
    echo "�п�J�Q�n�ˬd���ϥΪ̦W��:"
    echo "��J q �^�D���."
    read user_name
    check_ID_usability $user_name || return $to_adv_opmenu
    show_unsuccessful_login_count
    echo ''
    show_host_last_login
}
main
