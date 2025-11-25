/u01/install/APPS/scripts/startdb.sh
mkdir ~/log ; cd ~/log
echo -e 'PASSSYSADMIN\nPASSSYSADMIN\n' | /u01/install/APPS/scripts/enableSYSADMIN.sh
echo -e 'PASSDEMO\nPASSDEMO\n' | /u01/install/APPS/scripts/enableDEMOusers.sh
echo -e 'PASSALLSCHEMAS\nPASSALLSCHEMAS\nmanager\n' | /u01/install/APPS/scripts/changeDBpasswords.sh
grep 'changed successfully' L*.log && egrep -i 'error|failed|invalid' L*.log
. /u01/install/APPS/19.0.0/EBSCDB_apps.env
sqlplus / as sysdba<<EOF
alter user SYSTEM identified by PASSWORDSYSTEM ;
alter user SYS identified by PASSWORDSYS ;
alter session set container = EBSDB ;
alter user EBS_SYSTEM identified by PASSWORDEBSSYSTEM ;
exit
EOF
/u01/install/APPS/scripts/startapps.sh
. /u01/install/APPS/EBSapps.env run
echo -e 'welcome1\napps\n' | adadminsrvctl.sh start
echo -e 'Yes\n\nwelcome1\nPASSWEBLOGIC\napps\n'| perl $FND_TOP/patch/115/bin/txkUpdateEBSDomain.pl -action=updateAdminPassword
chmod 700 /u01/install/APPS/scripts/st*apps.sh
sed -i 's/welcome1/PASSWEBLOGIC/' /u01/install/APPS/scripts/st*apps.sh
cd ~/log
/u01/install/APPS/scripts/startapps.sh
. /u01/install/APPS/EBSapps.env run
echo -e 'apps\nPASSWEBLOGIC\n' | /u01/install/APPS/scripts/enableISG.sh
. /u01/install/APPS/EBSapps.env run
echo -e 'http\nappliebspublic\ndomainexample.com\n8000\nEBSDB\napps\n' | /u01/install/scripts/configwebentry.sh
/u01/install/APPS/scripts/stopapps.sh
/u01/install/APPS/scripts/stopdb.sh
exit
