# Class: int_graphite::carbon_c_relay::install
#
# Actions:
#  Install packages for graphite carbon-c
#
class int_graphite::carbon_c_relay::install () inherits int_graphite::params {

  package { carbon-c-relay :
      ensure => present,
  }

}
