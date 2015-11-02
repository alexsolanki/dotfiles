# Class: int_graphite::carbon_c_relay::configure
#
# Actions:
#  Configuration class for graphite carbon-c
#
class int_graphite::carbon_c_relay::configure (
  $local_cache    = $::int_graphite::params::local_cache,
  $remote_cache   = $::int_graphite::params::remote_cache,
  $port_start     = $::int_graphite::params::port_start,
  $port_end       = $::int_graphite::params::port_end
) inherits int_graphite::params {

  file {
    '/etc/sysconfig/carbon-c-relay':
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
      source => 'puppet:///modules/int_graphite/carbon_c_relay/carbon-c-relay',
      notify => Service['carbon-c-relay'],;
    '/etc/carbon-c-relay.conf':
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('int_graphite/carbon_c_relay/carbon-c-relay.conf.erb'),
      notify => Service['carbon-c-relay'],;
  }

  service { 'carbon-c-relay':
    ensure => 'running',
    enable => true,
  }
}
