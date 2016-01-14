# Class: int_zookeeper
#
# Actions:
#  Base class for Zookeeper
#
class int_zookeeper () {

  class { 'int_zookeeper::install':
  }->
  class { 'int_zookeeper::configure':
  }

}
