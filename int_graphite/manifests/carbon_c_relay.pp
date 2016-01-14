# Class: int_graphite::carbon_c_relay
#
# Actions:
#  Class for graphite carbon_c_relay
#
class int_graphite::carbon_c_relay () inherits int_graphite::params {

  class { 'int_graphite::carbon_c_relay::install':
  }->
  class { 'int_graphite::carbon_c_relay::configure':
  }

}
