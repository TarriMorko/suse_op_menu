#!/bin/bash
#
#
###############################################################################
# r2_show_machine_serial.sh
# show SystemModel and Machine Serial
###############################################################################

GetSystemModel() {
    System_Model=$(dmidecode -s system-product-name)
    if [ "${System_Model}" == "" ]; then
        writelog '查詢機型失敗'
    else
        writelog '此機器機型是' "$System_Model"
        writelog '查詢機型成功'
    fi
}

GetMachine_Serial() {
    Machine_Serial=$(dmidecode -s system-serial-number)
    if [ "${Machine_Serial}" == "" ]; then
        writelog '查詢機號失敗'
    else
        writelog '此機器機號是' "$Machine_Serial"
        writelog '查詢機號成功'
    fi
}

main() {
    GetSystemModel
    GetMachine_Serial
}
main