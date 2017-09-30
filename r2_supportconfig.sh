#!/bin/bash
#
#
###############################################################################
# r2_supportconfig.sh
# Use supportconfig -R /src/support to gather system configuration information.
###############################################################################

source ./tools/execute_supportconfig.sh
if [ $? -ne 0 ]; then
    echo "Can not include ./tools/execute_supportconfig.sh"
    exit 1
fi

OUTPUT_DIR="/source/sc"
file_prefix="$(hostname)_$(date +%Y%m%d_%H%M%S)"
ScriptName="r2_supportconfig.sh"

main() {
  comfirm_and_show_warning
  remove_old_support_dir
  execute_supportconfig
}

if [[ "$(basename -- "$0")" == "${ScriptName}" ]]; then
  main
  exit 0
fi
