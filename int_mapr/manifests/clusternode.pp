# Class: int_mapr::clusternode
#
# Actions: Base class for MapR Cluster Nodes
#
class int_mapr::clusternode(
  $mapr_version = undef,
  $mapreduce_version = undef,
) {

  class { 'int_mapr::clusternode::install':
    mapr_version      => $mapr_version,
    mapreduce_version => $mapreduce_version,
  }->
  class { 'int_mapr::clusternode::configure':
  }

}
