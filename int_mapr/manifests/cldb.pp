# Class: int_mapr::cldb
#
# Actions: Base class for MapR CLDB
#
class int_mapr::cldb () {

  class { 'int_mapr::cldb::install':
  }->
  class { 'int_mapr::cldb::configure':
  }

}
