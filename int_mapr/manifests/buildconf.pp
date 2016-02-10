# Class: int_mapr::buildconf
#
# Actions:
#   Class to build a MapR cluster configuration
#
class int_mapr::buildconf (
    $cluster_name = undef,
    $cldb_hosts = undef,
    $zookeeper_hosts = undef,
    $resource_hosts= undef,
    $history_server = undef,
) {

  # Build command line arguments for configure script
  $mapr_configure = [
    '/opt/mapr/server/configure.sh',
    # Verbose information
    '-v',
    # Don't start Warden automatically.
    '-no-autostart',
    # Cluster name
    '-N', $cluster_name,
    # CLDB Host list
    '-C', $cldb_hosts,
    # Zookeeper Host list
    '-Z', $zookeeper_hosts,
    # Resource manager
    '-RM', $resource_hosts,
    # Resource manager
    '-HS', $history_server,
    # User and group for running MapR services
    '-u', 'mapr',
    '-g', 'mapr',
    # Disk options:
    # -F Forces formatting of all specified disks.
    # -M Uses the maximum available number of disks per storage pool.
    '-disk-opts', 'FM',
  ]
  $mapr_configure_cmd = inline_template("<%=mapr_configure.join(' ')%>")

  # Files
  file { '/apps/bin/mapr_configure_command':
    mode    => '0644',
    content => $mapr_configure_cmd,
  }

}
