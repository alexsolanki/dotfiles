# Class: int_graphite::carbon_cache::runtime
#
# Actions:
#  Runtime management for graphite carbon-cache
#
class int_graphite::carbon_cache::runtime (
  $carbon_cache_daemon_subscribe = $::int_graphite::params::carbon_cache_daemon_subscribe
  $carbon_cache_httpd_subscribe  = $::int_graphite::params::carbon_cache_httpd_subscribe
) inherits int_graphite::params {

  # Service defaults:
  Service {
    ensure => running,
    enable => true,
    hasrestart => true,
    hasstatus => true;
  }

  # Services
  service {
    'carbon-cache':
      hasrestart => false,
      hasstatus  => false;
      subscribe  => $carbon_cache_daemon_subscribe,
    'carbon-relay':
      ensure     => stopped,
      enable     => false;
    'httpd':
      ensure     => running;
      subscribe  => $carbon_cache_httpd_subscribe,
    'memcached':
      ensure     => stopped,
      enable     => false;
    'iptables':
      ensure     => stopped,
      enable     => false;
  }
}
