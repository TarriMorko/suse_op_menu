SCRIPT_VERSION=1.0.1

if ! [ -f /src/mwadmin/mwadmin.sh ]; then
    echo ""
    echo "No /src/mwadmin/mwadmin.sh !  script STOP!"
    echo ""
    exit
fi

if ! [ -f /etc/SuSE-release ]; then
    echo ""
    echo "This script is for SuSE Linux!"
    echo ""
    exit
fi

cd /src/mwadmin
cp /src/mwadmin/mwadmin.sh /src/mwadmin/mwadmin.sh.$(date +%Y%m%d)
awk '/^q)/{print "\n" "z)" "\n""  clear" "\n""  echo \"Start adv opmenu at \"$(date)" "\n""  ${HAADMIN_HOME}/mw_hc2.sh" "\n""  echo \"Press enter to continue\"" "\n""  cd / " "\n""  read null" "\n""  ;;" "\n"}1' mwadmin.sh > tmp.$$
mv tmp.$$ mwadmin.sh

touch mw_hc2.err
touch mw_hc2.log
chmod 640 mw_hc2.err
chmod 640 mw_hc2.log
chmod 740 mw_hc2.sh
chmod 740 r1_check_unsuccessful_login_count.sh
chmod 740 r2_show_machine_serial.sh
chmod 740 r3_execute_supportconfig.sh
chmod 740 r4_check_FS_size.sh
chmod 740 r5_show_cpu_usage.sh
chmod 740 r6_show_mem_usage.sh
chmod 740 rotatelogs.sh
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
chown root:system rotatelogs.sh
chown root:system writelog.sh