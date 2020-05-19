#!/bin/bash

# unhash the env command below if you are having problems running the script as you can see what env existed in that phase
# env

# test for testing
if [ -z "$1" ]; then
	echo "To test this script use this syntax:  $0 test xxxx.sql"
	echo "Make sure you have exported orahome and databasesid variables as well with syntax like:"
	echo "export orahome=<oracle home dir>"
	echo "export databasesid=<SID of mounted Oracle DB>"
	exit 0
fi

# You don't need to set any variables unless you are manually running this script
# ORACLE_SID is learned from env variable databasesid that exists during mount, but not manual test
# ORACLE_HOME is learned from env variable orahome that exists only during certain parts of mount, but not manual test
# sqlscriptname is learned by $2 passed to script during mount, but not manual test

#  if $2 is not set then the sql script name will be empty
if [ -z "$2" ]; then
        echo "The variable which defines the SQL script to be run was not passed to the script"
        echo "In a workflow you need to put the SQL file name after the script name"
	echo "If manually executing put the SQL file name after the word test, for example:"
	echo "$0 test workflow.sql"
        exit 1
fi
# now check that the SQL file exists
if [ -f /act/scripts/$2 ]; then
        sqlscriptname=$(echo "$2")
else
        echo "The file specified $2 does not exist as /act/scripts/$2"
        echo "Please check that the correct file was specified"
        exit 1
fi

workflowfunc()
{
if [ -z "$orahome" ] || [ -z "$databasesid" ];then
	echo "Make sure you have exported orahome and databasesid variables as well with syntax like:"
	echo "export orahome=<oracle home dir>"
	echo "export databasesid=<SID of mounted Oracle DB>"
	exit 1
fi
ORACLE_HOME=$orahome
ORACLE_SID=$databasesid
oraclecommand="cd /act/scripts;export ORACLE_HOME=$ORACLE_HOME;export ORACLE_SID=$ORACLE_SID;export PATH=$ORACLE_HOME/bin:$PATH;ORAENV_ASK=NO;sqlplus / as sysdba @/act/scripts/$sqlscriptname;exit"
echo "$oraclecommand"
su -m oracle -c "$oraclecommand"
}

# this part of the script ensures we run the masking during a mount 
if [ "$ACT_MULTI_OPNAME" == "mount" ] && [ "$ACT_MULTI_END" == "true" ] && [ "$ACT_PHASE" == "post" ]; then
        workflowfunc
        exit $?
fi

# this part of the script ensures we run the masking during a scrub mount 
if [ "$ACT_MULTI_OPNAME" == "scrub-mount" ] && [ "$ACT_MULTI_END" == "true" ] && [ "$ACT_PHASE" == "post" ]; then
        workflowfunc
        exit $?
fi

# this lets us run this script manually
if [ "$1" == "test" ]; then
        workflowfunc
        exit $?
fi
