#!/bin/bash
# whisper-cleanup - moves errant files out of the root of the whisper path
# c Fri Aug 15 15:06:06 PDT 2014 smb
# u Fri Aug 15 15:06:06 PDT 2014 smb

# Variables
DATE=`/bin/date +%Y-%m-%d`

# Paths
WHISPER_PATH="/ramdisk/whisper"
WHISPER_ARCHIVE="/opt/graphite/storage/archive/${DATE}"
ACCEPTED_PATHS_ARG=$1
ACCEPTED_PATHS_EXCLUDED=`echo $ACCEPTED_PATHS_ARG | sed 's/^/,/g' | sed 's/,/ ! -name /g'`
PIDFILE="/var/run/whisper-cleanup"

# Exit codes
PREVIOUS_EXITCODE=0
STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3
STATE_DEPENDENT=4

# Default to UNKNOWN if no other code is set later
EXITCODE=$STATE_UNKNOWN

# Exit right away if plugin is already running.
if [ -e $PIDFILE ]; then
        ps -p `cat $PIDFILE` &>/dev/null
        PSEXIT="$?"
        if [ "$PSEXIT" -ne "0" ]; then
                echo "PID file found at $PIDFILE, but process not found, removing PID file, and exiting."
                rm -f $PIDFILE
        else
                echo "PID file found at $PIDFILE and running process matches that PID, exiting."
        fi
        exit $EXITCODE
fi

# Grab userid
ID=`/usr/bin/id -u`

# Check user
if [ $ID -ne "0" ]; then
        echo
        echo "Error: you MUST run this script as root."
        echo
        exit $EXITCODE
fi

# Otherwise, create a pid
echo $$ > $PIDFILE

# Move the errant files to an archive directory
mkdir -p $WHISPER_ARCHIVE
/usr/bin/find $WHISPER_PATH -mindepth 1 -maxdepth 1 $ACCEPTED_PATHS_EXCLUDED -exec mv {} $WHISPER_ARCHIVE \;

# Exit accordingly.
# "Anything more than a whisper and it would vanish"
EXITCODE=$STATE_OK
rm -f $PIDFILE
exit $EXITCODE

