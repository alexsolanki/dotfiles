# Class: int_graphite::carbon_c::install
#
# Actions:
#  Install packages for graphite carbon-c
#
class int_graphite::carbon_c::install () inherits int_graphite::params {

  package { carbon-c-relay :
      ensure => present,
  }

}
