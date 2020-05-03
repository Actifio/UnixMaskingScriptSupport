#!/bin/bash

# the line run in the  mask function can be substituted for your own masking software.   In this example it calls a SQL script
# You need to validate all the variables
# Is your ORACLE_SID the one called by workflow?  In this example it is called:  prepdmdb
# Is your ORACLE_HOME correct?  In this example it is:  /home/oracle/app/oracle/product/12.2.0/dbhome_1
# Is the SQL script being called the correct one?   In this example it is called: maskscript.sql

maskfunc()
{
su - oracle -c "cd /act/scripts;export ORACLE_SID=prepdmdb;export ORACLE_HOME=/home/oracle/app/oracle/product/12.2.0/dbhome_1;export PATH=$ORACLE_HOME/bin:$PATH;ORAENV_ASK=NO;sqlplus / as sysdba @/act/scripts/maskscript.sql;exit"
}

# this part of the script ensures we run the masking during a liveclone scrub mount after the database is started on the scrubbing server
if [ "$ACT_MULTI_OPNAME" == "scrub-mount" ] && [ "$ACT_MULTI_END" == "true" ] && [ "$ACT_PHASE" == "post" ]; then
	maskfunc
	exit $?
fi

# this part of the script ensures we run the masking during a direct mount after the database is started on the target server
if [ "$ACT_MULTI_OPNAME" == "mount" ] && [ "$ACT_MULTI_END" == "true" ] && [ "$ACT_PHASE" == "post" ]; then
	maskfunc
	exit $?
fi


# if the user is running this manually then tell them to use test
if [ -z "$1" ] && [ -z "$ACT_PHASE" ]; then
	echo "To run this script manually, use the following syntax:   $0 test"
	exit 0
fi

# this lets us run this script manually
if [ "$1" == "test" ]; then
	maskfunc
	exit $?
fi

exit 0
