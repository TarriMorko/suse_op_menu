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
        echo '離開、回到選單。'
        return 2
    fi

    if [[ "${user_name}" = "" ]]; then
        echo '請輸入帳號名稱。'
        return 1
    fi

    if [[ "${user_name}" =~ " " ]]; then
        echo '請輸入帳號名稱。'
        return 1
    fi

    id $user_name >/dev/null 2>&1

    if ! [[ $? -eq 0 ]]; then
        echo '帳號錯誤、請輸入正確帳號名稱。'
        return 1
    fi
}

show_unsuccessful_login_count() {
    unsuccessful_login_count=$(pam_tally2 -u $user_name |
        tail -n 1 | awk '{print $2}')
    if [[ "${unsuccessful_login_count}" = "" ]]; then
        err '無法取得 unsuccessful_login_count'
        return 1
    fi

    if [ ${unsuccessful_login_count} -gt 5 ]; then
        writelog "帳號 $user_name 登入密碼錯誤 $unsuccessful_login_count 次，帳號已被鎖定。請帳號擁有者洽資管科解鎖。"
    else
        writelog "帳號 $user_name 登入密碼錯誤 $unsuccessful_login_count 次"
    fi
}

show_host_last_login() {
    lastlog --user $user_name
}

main() {
    echo "請輸入想要檢查的使用者名稱:"
    echo "輸入 q 回主選單."
    read user_name
    check_ID_usability $user_name || return $to_adv_opmenu
    show_unsuccessful_login_count
    echo ''
    show_host_last_login
}
main
