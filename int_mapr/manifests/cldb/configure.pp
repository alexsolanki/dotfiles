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

  int_mapr::mapr_configure (
    $cluster_name = $cluster_name,
    $cldb_hosts = $cldb_hosts,
    $zookeeper_hosts = $zookeeper_hosts,
  ) { 'cldb': }

  if $mapr_ensure_service == true {
    service {
      'mapr-warden':
        ensure  => 'running',
    }
  }

}
