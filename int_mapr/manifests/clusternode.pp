# Class: int_mapr::clusternode
#
# Actions: Base class for MapR Cluster Nodes
#
class int_mapr::clusternode() {

  class { 'int_mapr::clusternode::install':
  }->
  class { 'int_mapr::clusternode::configure':
  }

}
