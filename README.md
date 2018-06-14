# Bacula Restore Test V1.2 #

Bacula automated recovery test script is applicable to Bacula version 7 or more.

## V1.2 version update: ##

- Modify part of the content to make the script more general
- Modify the FOR loop to the background execution
- Increase the self naming channel, define the concurrent number of FOR loops, reduce the occupation of system resources, and prevent errors caused by insufficient resources
- Wait+ backstage SHELL executes and restricts the number of loop concurrency, which can cope with more than 100 JOB recovery tests

## Function: ##

- Generality
- The number of custom recovery test files
- Custom loop concurrency number
- Occupying system resources can restore more than 100 JOB at the same time

## Custom parameters: ##

- Restore the backup storage host：RESTORE_CLIENT
- Restore the number of files：FILES_PER_JOB
- Self named pipe file：BAKFIFOFILE
- Loop concurrent number：CONCURRENT
- Restore file list and restore file storage path：/backup/vol1/BaculaRestoreTest/

## Matters needing attention： ##

Client name and Job naming rule in Bacula configuration

- Client Name: server name + -fd, for example: bakXXX-fd Job Name: Backup+ server name, for example: Backup-bakXXX
- Take care to distinguish case from case and keep name consistency

Job processing rules in bacula-dir configuration

- Client, which is no longer a backup plan, and the corresponding job are deleted in the configuration in time
- The client that temporarily or temporarily suspends the backup plan and the corresponding job are promptly annotated in the configuration to prevent automatic recovery test scripts from reading
