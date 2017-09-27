#!/bin/bash
#
#

# >/dev/null 2>&1

test_check_ID_usability() {

    check_ID_usability
    assertTrue '無輸入驗證失敗' "[ $? -gt 0 ]"

    check_ID_usability ' '
    assertTrue '空字串驗證失敗' "[ $? -gt 0 ]"

    check_ID_usability '\t'
    assertTrue '無效字串驗證失敗' "[ $? -gt 0 ]"

    check_ID_usability q
    assertTrue '輸入 q 無法退出。' "[ $? -eq 2 ]"

    check_ID_usability Q
    assertTrue '輸入 q 無法退出。' "[ $? -eq 2 ]"

}

oneTimeSetUp() {
    # load include to test
    . ../r1_check_unsuccessful_login_count.sh
    assertTrue 'Log檔不存在。' "[ -r $LOGFILENAME ]"
    assertTrue 'ErrorLog檔不存在。' "[ -r $ERRFILENAME ]"
}

. ./shunit2
