#!/bin/bash
#
#
###############################################################################
# r3_supportconfig.sh
# Use supportconfig -R /src/support to gather system configuration information.
###############################################################################

source $(dirname -- $0)/execute_supportconfig.sh

ScriptName="r3_supportconfig.sh"

main() {
    comfirm_and_show_warning
    remove_old_support_dir
    execute_supportconfig
    $(dirname -- $0)/scp_to_file_server.sh ${OUTPUT_DIR}/nts_${file_prefix}.tgz
}

if [[ "$(basename -- "$0")" == "${ScriptName}" ]]; then
    source $(dirname -- $0)/writelog.sh
    OUTPUT_DIR="/source/supportconfig"
    file_prefix="$(hostname)_$(date +%Y%m%d_%H%M%S)"
    main
    exit 0
fi
