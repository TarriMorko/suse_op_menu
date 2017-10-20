writelog() {
    #######################################
    # Writing log to specify file
    # Globals:
    #    LOGFILENAME
    # Arguments:
    #    _caller
    #    log_message
    # Returns:
    #    None
    # Example:
    #    write_log "Hello World!"
    # then a message "2014-11-22 15:38:54 [who_call] Hello World!"
    # writing in file LOGFILENAME.
    #######################################
    #_caller=$(echo $0 | cut -d'/' -f2)
    _caller=$(echo ${0##*/} | awk '{print substr($0,1,2)}')
    log_message=$@
    echo "$(date +"%Y-%m-%d %H:%M:%S") [$_caller] ${log_message}" | tee -a ${LOGFILENAME}
}
typeset -fx writelog

err() {
    #######################################
    # Writing log to specify file
    # Globals:
    #    ERRFILENAME
    # Arguments:
    #    _caller
    #    log_message
    # Returns:
    #    None
    # Example:
    #    err "Hello ERROR!"
    # then a message "2014-11-22 15:38:54 Hello ERROR!"
    # writing in file ERRFILENAME and STDERR.
    #######################################
    _caller=${0##*/}
    log_message=$1
    echo "$(date +"%Y-%m-%d %H:%M:%S") [$_caller] ${log_message}" | tee -a ${ERRFILENAME} >&2
}
typeset -fx err
