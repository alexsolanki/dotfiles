# Class: int_mapr::resourcemanager
#
# Actions: Base class for MapR Resource Manager
#
class int_mapr::resourcemanager () {

  class { 'int_mapr::resourcemanager::install':
  }->
  class { 'int_mapr::resourcemanager::configure':
  }

}
