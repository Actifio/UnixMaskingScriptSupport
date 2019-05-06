#!/bin/bash

maskfunc()
{
PATH=/opt/ibm/ODPP/bin:$PATH
EXTPROC_DLLS=ANY
LD_LIBRARY_PATH=/opt/ibm/ODPP/bin:$ORACLE_HOME/lib:$LD_LIBRARY_PATH
ODPPLL=/opt/ibm/ODPP/license
ODPPERRL=/opt/ibm/ODPP/include
ODPPLIBL=/opt/ibm/ODPP/bin
ODPPTRCL=/opt/ibm/ODPP/udftrc
ODPPICUDIR=/opt/ibm/ODPP/icufiles

su - oracle -c "export ORACLE_SID=optimdb; sqlplus / as sysdba @/opt/ibm/ODPP/scripts/registerudfs.ext" > out1.out

sleep 1m

su - oracle -c "export ORACLE_SID=optimdb; sqlplus / as sysdba @/act/scripts/udf_script.sql" > out2.out
}

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
