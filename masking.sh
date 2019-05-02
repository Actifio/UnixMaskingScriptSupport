#!/bin/bash
# the three exported variables need to be modified to suit your implementation if using SQL script above.
export ORACLE_HOME=/home/oracle/app/oracle/product/11.2.0/dbhome_1
export PATH=/usr/lib64/qt-3.3/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/home/oracle/bin:$ORACLE_HOME/bin
export ORACLE_SID=prepdmdb
ORAENV_ASK=NO

echo exit | sqlplus / as sysdba @maskscript.sql
