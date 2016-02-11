#!/bin/bash
# /apps/bin/disk-failure-auditor
#   Detects MapR DataNode disk failures, and removes DataNodes from rotation if
#   failures are found.

# Dynamically source script name.
SCRIPT=$(/usr/bin/env basename $0)

# Constants.
CLUSTER_DISKS=`/usr/bin/facter -p maprcd_blockdevices | sed 's/\(^\|,\)\/dev\// /g'`
EMAIL="eng-dcops@rubiconproject.com,eng-infrastructure@rubiconproject.com,prodsyseng@rubiconproject.com"
FAILED_TOPOLOGY="/decommissioned/faileddisks"
JIRA_AUTH_KEY="bWFwci11c2VyQHJ1Ymljb25wcm9qZWN0LmNvbToyRUZEQjE4M0U4Qzg3MDE0NjRDOTRGRENGNkMwNzJCNDlFNDE2RjIxMkY1RkUyMzU3NDMyNjkyNkFENzc5MjM3"
JIRA_HOSTNAME="fopp-jir2000.las1.fanops.net"
JIRA_ISSUE_TYPE="OPS Maintenance"
JIRA_PORT=8080
JIRA_PROJECT="DCOPS"
JIRA_URL="http://jira.rubiconproject.com"
LOGDIR="/var/log"
LOGFILE="${SCRIPT}.log"
MINIMUM_ACTIVE_DATANODE_PERCENTAGE=80
VALIDATION_TAG="/opt/trp/cluster-validation/logs/success"

# Exit codes.
STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3

# Default to UNKNOWN if no other code is set later.
EXITCODE=$STATE_UNKNOWN

# Variables.
DATACENTER=$(/usr/bin/facter -p fandatacenter | tr '[:lower:]' '[:upper:]')
DATE=$(/bin/date)
HOSTNAME=$(/bin/hostname)
SHORTNAME=$(/bin/echo $HOSTNAME | /bin/cut -d '.' -f 1,2)
USER=$(/usr/bin/id -un)

# Email function.
send_email() {
  EMAIL_SUBJECT="DataNode Disk Failure(s) Detected | ${TICKET_ID} | ${SHORTNAME}"

  EMAIL_BODY=$(
  /bin/cat << EOF
MapR cluster DataNode disk failure detected on: $SHORTNAME.

For more details, please reference: $JIRA_URL/browse/$TICKET_ID.

----

$BODY
EOF
  )

  /bin/echo "${EMAIL_BODY}" | /bin/mail -s "${EMAIL_SUBJECT}" $EMAIL
}

# Create JIRA ticket function.
create_jira_ticket() {
  SUMMARY=$(/bin/cat /tmp/diskfail.out)
  SERIAL_LIST=$(/bin/cat /tmp/jira_disks_shortlist.log | xargs | sed 's/ /, /g')
  DETAILS_LIST=$(/bin/cat /tmp/jira_disks_full_list.log)
  LOG_DUMP=$(/bin/cat /tmp/diskfail.log)
  LSHW_DUMP=$(/bin/cat /tmp/lshw_disks.log)

  SUBJECT="${DATACENTER} | Please investigate possible disk failure(s) on ${SHORTNAME} (${SERIAL_LIST})."

  BODY=$(
  /bin/cat << EOF
h5. Background

As time allows, please investigate possible hard disk failure(s) on $SHORTNAME, automatically detected by our MapR disk failure audit tool.

$DETAILS_LIST

Thank you!

----

h5. Failure Details

Topology Prior to Failure: {{$TOPO}}

{code}
[nobody@$SHORTNAME ~]$ cat /tmp/diskfail.out
$SUMMARY

[nobody@$SHORTNAME ~]$ sudo lshw -class storage -class disk
$LSHW_DUMP

[nobody@$SHORTNAME ~]$ cat /tmp/diskfail.log
$LOG_DUMP
{code}
EOF
  )

  DESCRIPTION=$(echo "${BODY}" | /usr/bin/perl -pe 's/\n/\\n/g')

  /bin/echo -e "Subject: ${SUBJECT}\n"
  /bin/echo "${BODY}"

  PAYLOAD=$(
  /bin/cat << EOF
{
  "fields": {
    "project":
    { 
      "key": "$JIRA_PROJECT"
    },
    "summary": "$SUBJECT",
    "description": "$DESCRIPTION",
    "issuetype": {
      "name": "$JIRA_ISSUE_TYPE"
    },
    "priority": {
      "name": "Low"
    }
  }
}
EOF
  )

  /bin/echo "${PAYLOAD}" > /tmp/jira_payload.log

  /bin/echo ''
  /bin/echo /usr/bin/curl -D- -X POST --data-binary "@/tmp/jira_payload.log" -H "Authorization: Basic ${JIRA_AUTH_KEY}" -H "Content-Type: application/json" http://$JIRA_HOSTNAME:$JIRA_PORT/rest/api/2/issue/
  /usr/bin/curl -D- -X POST --data-binary "@/tmp/jira_payload.log" -H "Authorization: Basic ${JIRA_AUTH_KEY}" -H "Content-Type: application/json" http://$JIRA_HOSTNAME:$JIRA_PORT/rest/api/2/issue/ | tee /tmp/jira_api_curl.log

  TICKET_ID=$(/bin/grep key /tmp/jira_api_curl.log | /bin/cut -d ',' -f 2 | /bin/cut -d ':' -f 2 | tr -d '"')
}

# Graceful exit function.
graceful_exit() {
  /bin/rm -f $PIDFILE
  exit $EXITCODE
}

# Exit right away if program is already running.
PIDFILE="/var/run/${SCRIPT}"

if [ -e $PIDFILE ]; then
  ps -p $(/bin/cat $PIDFILE) > /dev/null 2>&1
  PSEXIT="$?"
  if [ "$PSEXIT" -ne "0" ]; then
    /bin/echo -n "${DATE} "
    /bin/echo "PID file found at ${PIDFILE}, but process not found."
    /bin/echo "Removing PID file, and exiting."
    /bin/rm -f $PIDFILE
    EXITCODE=$STATE_WARNING
  else
    /bin/echo "PID file found at ${PIDFILE} and matching running process."
    /bin/echo "Exiting."
  fi
  exit $EXITCODE
fi

# Otherwise, create a pidfile.
echo $$ > $PIDFILE

# Exit if script is not run as root user.
if [ "$USER" != "root" ]; then
  /bin/echo -n "${DATE} "
  /bin/echo "This script requires elevated privileges to run. Try using sudo."
  EXITCODE=$STATE_WARNING
  graceful_exit
fi

# Ensure /tmp is writeable, and exit otherwise.
/bin/touch /tmp/write_test

if [ $? -ne 0 ] || [ ! -e /tmp/write_test ]; then
  /bin/echo -n "${DATE} "
  /bin/echo "File system write test failed: /tmp/write_test."
  EXITCODE=$STATE_UNKNOWN
  graceful_exit
fi

# Exit if at least one failed disk already detected.
if [ -e /tmp/failure_detected ]; then
  /bin/echo -n "${DATE} "
  /bin/echo "Previous disk failure sentinel file detected: /tmp/failure_detected."

  EXITCODE=$STATE_WARNING
  graceful_exit
fi

# Exit if MapR software isn't fully installed and configured.
if [ ! -e /usr/bin/maprcli ] || [ ! -e /opt/mapr/roles/tasktracker ]; then
  /bin/echo -n "${DATE} "
  /bin/echo "MapR CLI binary not found, or node not configured for TaskTracker role."

  EXITCODE=$STATE_WARNING
  graceful_exit
fi

# Exit if Node Auditor is already running.
/bin/ps -eflH | /bin/grep [n]ode-auditor 2> /dev/null

if [ $? -eq 0 ]; then
  /bin/echo -n "${DATE} "
  /bin/echo "Node Auditor running in background. Exiting to avoid race condition."

  EXITCODE=$STATE_WARNING
  graceful_exit
fi

# Exit if Node Auditor has not yet validated node.
if [ ! -e $VALIDATION_TAG ]; then
  /bin/echo -n "${DATE} "
  /bin/echo "Node Auditor success sentinel file not found: ${VALIDATION_TAG}."
  /bin/echo "Waiting for node validation to complete...exiting."

  EXITCODE=$STATE_WARNING
  graceful_exit
fi

# Exit if too many nodes are out-of-rotation.
TOTAL_NODES=$(/usr/bin/maprcli node list -filter [hn=="*com*"] -columns hn -noheader | /usr/bin/wc -l)
ACTIVE_NODES=$(/usr/bin/maprcli node list -filter [svc=="tasktracker"] -columns hn -noheader | /usr/bin/wc -l)

ACTIVE_PERCENTAGE=$(/bin/echo "${ACTIVE_NODES} * 100 / ${TOTAL_NODES}" | /usr/bin/bc)

if [ $ACTIVE_PERCENTAGE -lt $MINIMUM_ACTIVE_DATANODE_PERCENTAGE ]; then
  /bin/echo -n "${DATE} "
  /bin/echo "Less than ${MINIMUM_ACTIVE_NODE_PERCENTAGE}% active DataNodes. Aborting: ${ACTIVE_NODES} / ${TOTAL_NODES} = ${ACTIVE_PERCENTAGE}%."

  EXITCODE=$STATE_WARNING
  graceful_exit
fi

# Filter logs in preparation for iteration.
/bin/echo -n '' > /tmp/diskfail.out > /tmp/diskfail.log > /tmp/jira_disks_full_list.log > /tmp/jira_disks_shortlist.log > /tmp/jira_api_curl.log

if ! /bin/find /tmp/lshw_disks.log -mtime -1 2> /dev/null | /bin/grep lshw_disks.log > /dev/null 2>&1; then
  /usr/sbin/lshw -class storage -class disk > /tmp/lshw_disks.log
fi

/bin/dmesg | /bin/grep -i error > /tmp/dmesg_dump.log 2>&1
/bin/egrep "error|ERROR|ailed" /opt/mapr/logs/mfs.err /opt/mapr/logs/mfs.log-3* 2>&1 | /bin/egrep -i "/dev|disk" > /tmp/mfs_dump.tmp 2>&1
/bin/egrep "error|ERROR" /tmp/mfs_dump.tmp 2>&1 | /bin/egrep -v " 110|ContainerOfflineForBadDisk|nit failed|nvalid exchange| SP[0-9]" > /tmp/mfs_dump.log 2>&1
/bin/grep "ailed" /tmp/mfs_dump.tmp 2>&1 | /bin/egrep -v "loadsp|SP.:/dev/sd." >> /tmp/mfs_dump.log 2>&1

# Do what needs to be done.
for disk in $CLUSTER_DISKS; do
  FAILURE_FOUND=0
  SMART_CHECK=0

  /usr/sbin/smartctl -H /dev/$disk | /bin/grep PASSED > /dev/null 2>&1
  let "SMART_CHECK += ${?}"

  if [ $SMART_CHECK -ne 0 ]; then
    /usr/sbin/smartctl -x /dev/$disk >> /tmp/diskfail.log 2>&1
  fi

  /bin/grep $disk /tmp/dmesg_dump.log >> /tmp/diskfail.log 2>&1
  let "FAILURE_FOUND += ${?}"

  /bin/cat /opt/mapr/logs/$disk.failed.info >> /tmp/diskfail.log 2> /dev/null
  let "FAILURE_FOUND += ${?}"

  /bin/grep $disk /tmp/mfs_dump.log >> /tmp/diskfail.log 2>&1
  let "FAILURE_FOUND += ${?}"

  if [ $FAILURE_FOUND -ne 3 ] || [ $SMART_CHECK -ne 0 ]; then
    SLOT=$(/bin/grep -A 2 -B 6 $disk /tmp/lshw_disks.log | /bin/grep disk | xargs)
    SERIAL=$(/bin/grep -A 2 -B 6 $disk /tmp/lshw_disks.log | /bin/grep serial | sed 's/serial: //g' | xargs)
    /bin/echo "Disk failure detected: /dev/${disk} (${SLOT}, ${SERIAL})." >> /tmp/diskfail.out
    /bin/echo $SERIAL >> /tmp/jira_disks_shortlist.log
    /bin/echo -e "*Position*—/dev/${disk}\n*Serial*—${SERIAL}\n" >> /tmp/jira_disks_full_list.log
  fi
done

if [ $(cat /tmp/diskfail.out | /usr/bin/wc -l) -gt 0 ]; then
  # Log current rack topology.
  TOPO=$(/usr/bin/maprcli node list -columns hn,rp -filter [hn==$HOSTNAME] -json | /bin/grep racktopo | /bin/cut -d ':' -f 2 | tr -d '"')
  /bin/echo "Current Topology: ${TOPO}"

  # Pull node out of rotation.
  SERVERID=$(/usr/bin/maprcli node list -columns id -noheader | /bin/grep $HOSTNAME | /bin/awk '{ print $1 }')
  /bin/echo /usr/bin/maprcli node move -serverids $SERVERID -topology $FAILED_TOPOLOGY
  /usr/bin/maprcli node move -serverids $SERVERID -topology $FAILED_TOPOLOGY

  # Stop data processing services.
  /sbin/service mapr-warden stop
  /usr/bin/pkill -9 -u mapr
  /usr/bin/pkill -9 -u prodicon

  # Purge zombie MapR-FS node-local directories and volumes.
  /bin/echo "Purge zombie MapR-FS node-local directories and volumes."
  /usr/bin/sudo -u mapr /usr/bin/maprcli volume unmount -force 1 -name mapr.$HOSTNAME.local.logs
  /usr/bin/sudo -u mapr /usr/bin/maprcli volume remove -name mapr.$HOSTNAME.local.logs
  /usr/bin/sudo -u mapr /usr/bin/maprcli volume unmount -force 1 -name mapr.$HOSTNAME.local.mapred
  /usr/bin/sudo -u mapr /usr/bin/maprcli volume remove -name mapr.$HOSTNAME.local.mapred
  /usr/bin/sudo -u mapr /usr/bin/maprcli volume unmount -force 1 -name mapr.$HOSTNAME.local.metrics
  /usr/bin/sudo -u mapr /usr/bin/maprcli volume remove -name mapr.$HOSTNAME.local.metrics

  /usr/bin/hadoop fs -rmr /var/mapr/local/$(hostname)/logs
  /usr/bin/hadoop fs -rmr /var/mapr/local/$(hostname)/mapred
  /usr/bin/hadoop fs -rmr /var/mapr/local/$(hostname)/metrics

  # File JIRA ticket and send notification email.
  create_jira_ticket
  send_email

  # Create failed disk(s) sentinel file.
  touch /tmp/failure_detected

  # Exit with critical return code.
  EXITCODE=$STATE_CRITICAL
else
  EXITCODE=$STATE_OK
fi

# Back to sleep.
graceful_exit
