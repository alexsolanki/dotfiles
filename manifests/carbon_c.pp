# Class: int_graphite::carbon_c
#
# Actions:
#  Class for graphite carbon_c
#
class int_graphite::carbon_c () inherits int_graphite::params {

  class { 'int_graphite::carbon_c::install':
  }->
  class { 'int_graphite::carbon_c::configure':
  }

}
