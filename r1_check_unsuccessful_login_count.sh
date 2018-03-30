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
        echo 'exit.'
        return 2
    fi

    if [[ "${user_name}" = "" ]]; then
        echo 'Please input account name:'
        return 1
    fi

    if [[ "${user_name}" =~ " " ]]; then
        echo 'Please input account name:'
        return 1
    fi

    id $user_name >/dev/null 2>&1

    if ! [[ $? -eq 0 ]]; then
        echo 'Please input account name:'
        return 1
    fi
}

show_unsuccessful_login_count() {
    unsuccessful_login_count=$(pam_tally2 -u $user_name |
        tail -n 1 | awk '{print $2}')
    if [[ "${unsuccessful_login_count}" = "" ]]; then
        err 'Can not get unsuccessful_login_count'
        return 1
    fi

    if [ ${unsuccessful_login_count} -gt 5 ]; then
        writelog "Account $user_name login failed $unsuccessful_login_count times. Account LOCKED."
    else
        writelog "Account $user_name login failed $unsuccessful_login_count times."
    fi
}

show_host_last_login() {
    lastlog --user $user_name
}

main() {
    echo "Please input user name yout want to check."
    echo "input q to exit."
    read user_name
    check_ID_usability $user_name || return $to_adv_opmenu
    show_unsuccessful_login_count
    echo ''
    show_host_last_login
}
main
