# Class: int_zookeeper::install
#
# Actions:
#  Install packages for Zookeeper
#
class int_zookeeper::install (
  $zookeeper_version = hiera('int_zookeeper::zookeeper_version'),
) {

  package { 'zookeeper' :
      ensure => $zookeeper_version,
  }

}
