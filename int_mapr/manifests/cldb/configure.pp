# Class: int_mapr::cldb::configure
#
# Actions:
#   Class for MapR CLDB configuration
#
class int_mapr::cldb::configure (
  $cluster_name = hiera('int_mapr::cluster_name'),
  $cldb_hosts = hiera('int_mapr::cldb_hosts'),
  $zookeeper_hosts = hiera('int_mapr::zookeeper_hosts'),
  $mapr_ensure_service = false,
) {

  # Configure a cldb node
  class { 'int_mapr::buildconf':
    cluster_name    => $cluster_name,
    cldb_hosts      => $cldb_hosts,
    zookeeper_hosts => $zookeeper_hosts,
  }

  # Validate a cldb node
  class { 'int_mapr::validate': }

  if $mapr_ensure_service == true {
    service {
      'mapr-warden':
        ensure  => 'running',
    }
  }

}
