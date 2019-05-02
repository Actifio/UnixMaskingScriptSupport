#!/bin/bash

# the line run in the  mask function can be substituted for your own masking software.   In this example it calls a SQL script
maskfunc()
{
echo exit | sqlplus / as sysdba @/act/scripts/maskscript.sql
}

# the three exported variables need to be modified to suit your implementation if using SQL script above.
export ORACLE_HOME=/home/oracle/app/oracle/product/11.2.0/dbhome_1
export PATH=/usr/lib64/qt-3.3/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/home/oracle/bin:$ORACLE_HOME/bin
export ORACLE_SID=prepdmdb
ORAENV_ASK=NO

# this part of the script ensures we run the masking during a scrub mount after the database is started on the scrubbing server
if [ "$ACT_MULTI_OPNAME" == "scrub-mount" ] && [ "$ACT_MULTI_END" == "true" ] && [ "$ACT_PHASE" == "post" ]; then
	maskfunc
	exit $?
fi

# this lets us run this script manually 
if [ "$1" == "test" ]; then
	maskfunc
	exit $?
fi

exit 0
