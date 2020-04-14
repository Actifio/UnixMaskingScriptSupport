#!/bin/bash

# the line run in the  mask function can be substituted for your own masking software.   In this example it calls a SQL script
maskfunc()
{
su -m oracle -c "/act/scripts/masking.sh"
}

# this part of the script ensures we run the masking during a scrub mount after the database is started on the scrubbing server
if [ "$ACT_MULTI_OPNAME" == "scrub-mount" ] && [ "$ACT_MULTI_END" == "true" ] && [ "$ACT_PHASE" == "post" ]; then
	maskfunc
	exit $?
fi

# if we are manually running the script remind the user how to test it
if [ -z "$1" ]; then
	echo "If you want to run this script as a test then please use the following command:"
	echo "$0 test"
fi


# this lets us run this script manually 
if [ "$1" == "test" ]; then
	maskfunc
	exit $?
fi

exit 0
