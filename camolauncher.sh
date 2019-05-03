#!/bin/bash

# the line run in the  mask function can be substituted for your own masking software.   In this example it calls a SQL script
maskfunc()
{
/opt/Camouflage/camouflage -nogui -projectfile /home/oracle/Mask-Demo.camo
wait $!
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
