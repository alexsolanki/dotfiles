# Class: int_mapr
#
# Actions:
#   Base class for MapR installations
#
class int_mapr () {

  class { 'int_mapr::install':
  }->
  class { 'int_mapr::configure':
  }

}
