#!/bin/bash
# backgraph - create simple TGZ backups of Graphite data
# Graphite: http://graphite.wikidot.com/
# c Fri Jan  7 11:39:39 PST 2011 smb
# u Fri Jan  7 11:39:39 PST 2011 smb
# u Fri Jan 27 17:16:19 PST 2012 smb
# u Thu Feb 13 14:48:27 PST 2014 smb - added random sleep up to 3 hours to stagger, also refuse to run on LAS1-side pairs
# u Thu Apr  2 12:11:53 PDT 2015 smb - dropping down to just 1 backup kept due to disk space concerns, highlighting the need for re-arc
# Sean Byron <sean@rubiconproject.com> - 01/07/2011 1.0.0
# - Initial package creation.
#

# Exit right away if plugin is already running. This will alert if max check attempts is reached.
PIDFILE="/var/run/backgraph.pid"

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

# Refuse to run on LAS1-side hosts so as not to impact frontend response times
# Except for cases where the LAS1-side host is a paired storage node for LAS1 data
DC=`/bin/hostname | cut -c 14-17`
SEQ=`/bin/hostname | cut -c 9-12`
if [ $SEQ == "0300" ]; then
	DC="noskip"
fi
if [ $DC == "las1" ]; then
        echo "Refusing to run on LAS1-side hosts so as not to impact frontend response times, exiting."
        exit 0
fi

# Otherwise, create a pid
echo $$ > $PIDFILE

# Variables
DATE=`/bin/date +%s`

# Paths
DIRLIVE="/ramdisk/whisper"
DIRBACK="/opt/graphite/storage/backups"

# Variables
TAR="tar -czf"
FILENAME="${HOSTNAME}.graphite-whisper.${DATE}.tgz"

# Sleep for a random amount of time (up to 3 hours)
SLEEP=$[ ( $RANDOM % 10800 )  + 1 ]
/bin/sleep $SLEEP

# Prepare (and delete backups too small)
mkdir -p $DIRLIVE $DIRBACK
find $DIRBACK -maxdepth 1 -mindepth 1 -type f  -size -100M -delete

# Backup
$TAR $DIRBACK/$FILENAME $DIRLIVE

# Purge old backups
find  $DIRBACK -maxdepth 1 -type f -printf '%T@ %p\0' | sort -r -z -n | awk 'BEGIN { RS="\0"; ORS="\0"; FS="" } NR > 1 { sub("^[0-9]*(.[0-9]*)? ", ""); print }' | xargs -0 rm -f

# Exit
rm -f $PIDFILE
exit 0
