#!/bin/bash
# /apps/bin/node-auditor.sh
#   Executes select portions of MapR cluster validation suite, logs the results,
#   adjusts rack topologies and files JIRA tickets, as appropriate.

# Dynamically source script name.
SCRIPT=$(/usr/bin/env basename $0)

# Exit codes.
STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3

# Variables.
DATACENTER=$(/usr/bin/facter -p 2> /dev/null | grep fandatacenter | awk '{ print toupper($3) }')
HOSTNAME=$(/bin/hostname)
SHORTNAME=$(echo $HOSTNAME | /bin/cut -d '.' -f 1,2)
USER=$(/usr/bin/id -un)
BASEPATH="/opt/trp/cluster-validation"
DISKCOUNT=12
DISKTESTRUNS=20
EXITCODE=$STATE_UNKNOWN
PIDFILE="/var/run/$SCRIPT.pid"

function usage {
cat << EOF

usage:$SCRIPT options

Executes select portions of MapR cluster validation suite, logs the results,
adjusts rack topologies and files JIRA tickets, as appropriate.

OPTIONS:
       -h      Show this messages
       -m      Test to run, memory, disk or all
EOF
}

while getopts "hm:" OPTION; do
    case $OPTION in
        h)
            usage
            exit 0
            ;;
        m)
            RUN_MODE="$OPTARG"
            ;;
        ?)
            usage
            exit 1
            ;;
    esac
done

if [[ -z $RUN_MODE ]]; then
    usage
    exit 1
fi

# Graceful exit function.
graceful_exit() {
  /bin/rm -f $PIDFILE
  if [[ $EXITCODE != 0 ]]; then
    touch $BASEPATH/logs/failure
  fi
  exit $EXITCODE
}

# Test Functions.
memory_test() {
  echo "INFO: Begin memory performance validation." > $BASEPATH/logs/memory-test.log
  $BASEPATH/pre-install/memory-test.sh 2>&1 | grep ^Triad >> $BASEPATH/logs/memory-test.log
  echo "INFO: End memory performance validation." >> $BASEPATH/logs/memory-test.log
  echo "INFO: Begin memory latency validation." >> $BASEPATH/logs/memory-test.log
  $BASEPATH/pre-install/memory-test.sh lat >> $BASEPATH/logs/memory-test.log 2>&1
  echo "INFO: End memory latency validation." >> $BASEPATH/logs/memory-test.log
}

disk_test() {
  echo "INFO: Begin disk performance validation." >> $BASEPATH/logs/disk-test.log

  for i in {1..$DISKTESTRUNS}; do
    $BASEPATH/pre-install/disk-test.sh > $BASEPATH/logs/disk-test.out.$i 2>&1
    /bin/grep -F '   1024' sd*-iozone.log | awk '{ print $1, $4, $5 }' > $BASEPATH/logs/results.log.$i 2>&1
  done

  /bin/cat $BASEPATH/logs/results.log.* >> $BASEPATH/logs/disk-test.log
  echo "INFO: End disk performance validation." >> $BASEPATH/logs/disk-test.log
}

# Exit if script is not run as root user.
if [ "$USER" != "root" ]; then
  echo "INFO: This script requires elevated privileges to run. Try using sudo."
  EXITCODE=$STATE_WARNING
  graceful_exit
fi

if [ -e $PIDFILE ]; then
  ps -p $(/bin/cat $PIDFILE) > /dev/null 2>&1
  PSEXIT="$?"
  if [ "$PSEXIT" -ne "0" ]; then
    echo "WARN: PID file found at $PIDFILE, but process not found."
    # Node Auditor should only ever run once.
    # Safer not to remove even a seemingly stale PID file.
    echo "INFO: Exiting."
    EXITCODE=$STATE_WARNING
  else
    echo "WARN: PID file found at $PIDFILE and matching running process."
    echo "INFO: Exiting."
  fi
  exit $EXITCODE
fi

# Otherwise, create a pidfile.
echo $$ > $PIDFILE

# Exit immediately if node validation has already been run.
if [[ -e $BASEPATH/logs/validation_runounce ]]; then
  echo "INFO: Previous validation sentinel file detected: ${BASEPATH}/logs/validation_runounce."
  EXITCODE=$STATE_WARNING
  graceful_exit
fi
touch ${BASEPATH}/logs/validation_runounce

# Run the tests!
if [ $RUN_MODE == 'all' ]; then
  memory_test
  disk_test
elif [ $RUN_MODE == 'memory' ]; then
  memory_test
elif [ $RUN_MODE == 'disk' ]; then
  disk_test
  # Validation!
  SUCCESS_EXPECTED=$(echo $DISKCOUNT * $DISKTESTRUNS | /usr/bin/bc -l)
  SUCCESS_COUNT=$(/bin/cat ${BASEPATH}/logs/disk-test.log | egrep "sd.-iozone.log: [12]..... [12]....." | wc -l)
  if [[ $SUCCESS_COUNT -lt $SUCCESS_EXPECTED ]]; then
    REASON="ERROR: Underperforming MapR data disks detected (SUCCESS_COUNT=${SUCCESS_COUNT}), see $BASEPATH/logs/disk-test.log"
    echo $REASON
    EXITCODE=$STATE_CRITICAL
    graceful_exit
  fi
elif [ $RUN_MODE == 'skip' ]; then
  echo -e "INFO: Skipping test"
else
  echo -e "ERROR: Not a valid mode"
  EXITCODE=$STATE_CRITICAL
  graceful_exit
fi

# Generate fresh MapR Host ID and Hostname idenitfy files.
echo "INFO: Generate fresh MapR Host ID and Hostname idenitfy files."
/opt/mapr/server/mruuidgen > /opt/mapr/hostid
/bin/cp /opt/mapr/hostid /opt/mapr/conf/hostid.$$
/bin/chmod 444 /opt/mapr/hostid
/bin/hostname -f > /opt/mapr/hostname

# Purge zombie MapR-FS node-local directories and volumes.
hdfs_dirs='logs mapred metrics'
echo "INFO: Purge zombie MapR-FS node-local directories and volumes if they exist."
for dir in $hdfs_dirs; do
  /usr/bin/maprcli volume info -name mapr.$HOSTNAME.local.$dir > /dev/null 2>&1
  result=$?
  if [ $result -eq 0 ]; then
    echo -e "INFO: Volume found unmounting and removing volume: mapr.$HOSTNAME.local.$dir"
    sudo -u mapr /usr/bin/maprcli volume unmount -force 1 -name mapr.$HOSTNAME.local.$dir
    sudo -u mapr /usr/bin/maprcli volume remove -name mapr.$HOSTNAME.local.$dir
  fi
  echo -e "INFO: Testing if HDFS paths exist"
  /usr/bin/hadoop fs -test -e /var/mapr/local/$HOSTNAME/$dir
  result=$?
  if [ $result -eq 0 ]; then
    echo -e "INFO: HDFS PATH exists removing: /var/mapr/local/$HOSTNAME/$dir"
    /usr/bin/hadoop fs -rm -r /var/mapr/local/$HOSTNAME/$dir
  fi
done

# Generating mapr devices
# Find the root volume, for example, sda1
echo -e "INFO: Generating Mapr devices"
sys_device=$(ls /dev/sd*1 | sed -e 's/1//')

# Grep out the root volume and take in the rest of the sd* devices
block_devices=$(ls -l /dev/sd* | grep -o '/dev/sd\w$' | grep -v $sys_device)

# Mash them all together
for device in $block_devices; do
  blockdevices+=$device
done

# Remove the last comma
MAPR_DEVICES=$(echo $blockdevices | sed -e 's/,$//')

# Trigger MapR configure command.
echo -e "INFO: Trigger MapR configure command."
echo -e "INFO: Running: $(cat /apps/bin/mapr_configure_command) -D $MAPR_DEVICES"
$(cat /apps/bin/mapr_configure_command) -D $MAPR_DEVICES
EXITCODE=$STATE_OK
touch ${BASEPATH}/logs/success

# Exit gracefully
graceful_exit
