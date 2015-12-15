# Class: int_graphite::params
#
# Actions:
#  Params class for int_graphite
#
class int_graphite::params {

  $local_cache           = hiera('int_graphite::params::local_cache')
  $remote_cache          = hiera('int_graphite::params::remote_cache')
  $port_start            = hiera('int_graphite::params::port_start')
  $port_end              = hiera('int_graphite::params::port_end')
  $carbon_c_relay_state  = hiera('int_graphite::params::carbon_c_relay_state')
  $carbon_c_relay_enable = hiera('int_graphite::params::carbon_c_relay_enable')

}
