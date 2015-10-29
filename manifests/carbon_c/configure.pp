# Class: int_graphite::carbon_c::configure
#
# Actions:
#  Configuration class for graphite carbon-c
#
class int_graphite::carbon_c::configure (
  $local_relay    = $::int_graphite::params::local_relay,
  $remote_relay   = $::int_graphite::params::remote_relay
) inherits int_graphite::params {

  file {
    '/etc/sysconfig/carbon-c-relay':
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
      source => 'puppet:///modules/int_graphite/carbon_c/carbon-c-relay',;
    '/etc/carbon-c-relay.conf':
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('int_graphite/carbon_c/carbon-c-relay.conf.erb'),;
  }

}
