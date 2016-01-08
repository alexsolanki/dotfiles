# Class: int_graphite::carbon_cache::runtime
#
# Actions:
#  Runtime management for graphite carbon-cache
#
class int_graphite::carbon_cache::runtime () inherits int_graphite::params {

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
      hasstatus => false;
    'carbon-relay':
      ensure => stopped,
      enable => false;
    'httpd':
      ensure => running;
    'memcached':
      ensure => stopped,
      enable => false;
    'iptables':
      ensure => stopped,
      enable => false;
  }
}
