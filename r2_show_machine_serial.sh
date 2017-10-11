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
        writelog '�d�߾�������'
    else
        writelog '�����������O' "$System_Model"
        writelog '�d�߾������\'
    fi
}

GetMachine_Serial() {
    Machine_Serial=$(dmidecode -s system-serial-number)
    if [ "${Machine_Serial}" == "" ]; then
        writelog '�d�߾�������'
    else
        writelog '�����������O' "$Machine_Serial"
        writelog '�d�߾������\'
    fi
}

main() {
    GetSystemModel
    GetMachine_Serial
}
main