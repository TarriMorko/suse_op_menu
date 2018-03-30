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
        writelog 'Query product-name failed'
    else
        writelog 'product-name is' "$System_Model"
        writelog 'Query success'
    fi
}

GetMachine_Serial() {
    Machine_Serial=$(dmidecode -s system-serial-number)
    if [ "${Machine_Serial}" == "" ]; then
        writelog 'Query serial-number failed'
    else
        writelog 'serial-number is' "$Machine_Serial"
        writelog 'Query success'
    fi
}

main() {
    GetSystemModel
    GetMachine_Serial
}
main