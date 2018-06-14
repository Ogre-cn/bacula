#!/bin/bash
#
# Bacula Restore Test V1.2
#
# Applicable to Bacula V7.0+
#
# Edited by Ogre
#
############################

RESTORE_CLIENT=bacula-fd
FILES_PER_JOB=15

BAKFIFOFILE=/backup/vol1/BaculaRestoreTest/bak.fifo
CONCURRENT=5

mkfifo $BAKFIFOFILE
exec 8<> $BAKFIFOFILE
rm -rf $BAKFIFOFILE

for i in `seq $CONCURRENT`
do
    echo >&8
done

for JOBNAME in $(echo ".jobs" |/usr/sbin/bconsole | sed "1,4d"|grep Backup*)
do
    read -u 8
    {	
    JOBID=$(echo "list job=$JOBNAME" |/usr/sbin/bconsole |grep "| T" | awk -F"|" '$8!=0{print $0}' | tail -n 1 | cut -f 2 -d "|" | sed 's/[ ,]//g')

    if [ $JOBNAME = "BackupCatalog*" ];then
        CLIENT=$RESTORE_CLIENT            
        echo $CLIENT                 
        echo "list files jobid=$JOBID" |/usr/sbin/bconsole |head -n -7 | tail -n +10 |cut -d "|" -f 2 | sed 's/^ //g' | sort -R | head -n $FILES_PER_JOB | sed 's/[ \t]\+$//g' > /backup/vol1/BaculaRestoreTest/list-$JOBNAME
        echo "restore jobid=$JOBID client=$CLIENT restoreclient=$RESTORE_CLIENT restorejob=RestoreFiles file=</backup/vol1/BaculaRestoreTest/list-$JOBNAME where=/backup/vol1/BaculaRestoreTest/$JOBNAME select current all done yes" |/usr/sbin/bconsole
        continue                     
    fi                               

    CLIENT=$(echo "llist clients" |/usr/sbin/bconsole | grep -w [Nn]ame: | sed 's/[Nn]ame://g' | sed 's/ //g')

    NAME1=$(echo $JOBNAME |cut -d '-' -f 2)
    NAME2=$NAME1"-fd"                      
    
    echo $CLIENT|grep $NAME2 &>/dev/null  
    if [ $? != 0  ];then              
        continue                     
    else                             
        CLIENT=$NAME2                   
        echo $CLIENT                 
    fi 

    echo "list files jobid=$JOBID" |/usr/sbin/bconsole |head -n -7 | tail -n +10 |cut -d "|" -f 2 | sed 's/^ //g' | sort -R | head -n $FILES_PER_JOB | sed 's/[ \t]\+$//g' > /backup/vol1/BaculaRestoreTest/list-$JOBNAME

    echo "restore jobid=$JOBID client=$CLIENT restoreclient=$RESTORE_CLIENT restorejob=RestoreFiles file=</backup/vol1/BaculaRestoreTest/list-$JOBNAME where=/backup/vol1/BaculaRestoreTest/$JOBNAME select current all done yes" |/usr/sbin/bconsole
    echo >&8
    }&
done
wait
