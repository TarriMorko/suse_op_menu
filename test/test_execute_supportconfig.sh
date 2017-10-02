#!/bin/bash
#
#

# >/dev/null 2>&1

#   comfirm_and_show_warning
#   remove_old_support_dir
#   execute_supportconfig

test_remove_old_support_dir() {
    remove_old_support_dir
    file_count=$( ls ${OUTPUT_DIR} | wc -l )
    assertTrue 'Rotation failed.' "[ $file_count -lt 3 -o $file_count -eq 0 ]"
}

oneTimeSetUp() {
    # load include to test
    . ../tools/execute_supportconfig.sh
    assertTrue 'Log檔不存在。' "[ -r $LOGFILENAME ]"
    assertTrue 'ErrorLog檔不存在。' "[ -r $ERRFILENAME ]"
}

. ./shunit2
