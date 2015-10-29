# Class: int_graphite::carbon_c_relay::configure
#
# Actions:
#  Configuration class for graphite carbon-c
#
class int_graphite::carbon_c_relay::configure (
  $local_cache    = $::int_graphite::params::local_cache,
  $remote_cache   = $::int_graphite::params::remote_cache
) inherits int_graphite::params {

  file {
    '/etc/sysconfig/carbon-c-relay':
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
      source => 'puppet:///modules/int_graphite/carbon_c_relay/carbon-c-relay',;
    '/etc/carbon-c-relay.conf':
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('int_graphite/carbon_c_relay/carbon-c-relay.conf.erb'),;
  }

}
