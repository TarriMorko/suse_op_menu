#!/bin/sh
#
#
###############################################################################
# r4_check_FS_size.sh
# check FileSystem size
###############################################################################
# Globals variable :
#   defualt_FileSystem
#   SizeLowerLimit                    # size present by df
###############################################################################

echo ""
echo "Please Enter which FileSystem you want to check:"
echo "current setting is ${defualt_FileSystem}, press ENTER to use default setting."
echo ""

read fileSystem
if [[ -z "${fileSystem}" ]]; then
    fileSystem="${defualt_FileSystem}"
fi

df -m "${fileSystem}" 2>/dev/null 1>/dev/null
return_code=$?
if [ $return_code -ne 0 ]; then
    err "Error, Can not check ${fileSystem}."
    exit 1
fi

fileSystemSizeRemain=$(df -m "${fileSystem}" | tail -n 1 | awk '{print $3}')

if [ ${fileSystemSizeRemain} -gt ${SizeLowerLimit} ]; then
    writelog "$(hostname) ${fileSystem} enough, $fileSystemSizeRemain MB left."
else
    writelog "$(hostname) ${fileSystem} not enough, $fileSystemSizeRemain MB left."
fi
