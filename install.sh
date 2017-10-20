SCRIPT_VERSION=1.0.0

if ! [ -f /src/mwadmin/mwadmin.sh ]; then
    echo ""
    echo "No /src/mwadmin/mwadmin.sh !  script STOP!"
    echo "請手動安裝"
    echo ""
    exit
fi

cd /src/mwadmin
touch mw_hc2.err
toucn mw_hc2.log
chmod 640 mw_hc2.err
chmod 640 mw_hc2.log
chmod 740 mw_hc2.sh
chmod 740 r1_check_unsuccessful_login_count.sh
chmod 740 r2_show_machine_serial.sh
chmod 740 r3_execute_supportconfig.sh
chmod 740 r4_check_FS_size.sh
chmod 740 r5_show_cpu_usage.sh
chmod 740 r6_show_mem_usage.sh
chmod 740 r7_show_io_usage.sh
chmod 740 r8_copy_to_file_server.sh
chmod 740 rotatelogs.sh
chmod 740 scp_to_file_server.sh
chmod 740 writelog.sh

chown root:system mw_hc2.err
chown root:system mw_hc2.log
chown root:system mw_hc2.sh
chown root:system r1_check_unsuccessful_login_count.sh
chown root:system r2_show_machine_serial.sh
chown root:system r3_execute_supportconfig.sh
chown root:system r4_check_FS_size.sh
chown root:system r5_show_cpu_usage.sh
chown root:system r6_show_mem_usage.sh
chown root:system r7_show_io_usage.sh
chown root:system r8_copy_to_file_server.sh
chown root:system rotatelogs.sh
chown root:system scp_to_file_server.sh
chown root:system writelog.sh