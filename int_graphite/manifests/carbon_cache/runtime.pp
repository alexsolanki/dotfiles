# Class: int_graphite::carbon_cache::runtime
#
# Actions:
#  Runtime management for graphite carbon-cache
#
class int_graphite::carbon_cache::runtime () inherits int_graphite::params {

  # Variables
  $carbon_cache_daemon_subscribe = ['/opt/graphite/conf/storage-aggregation.conf', '/opt/graphite/conf/storage-schemas.conf', '/etc/security/limits.d/graphite_storage.conf', '/etc/init.d/carbon-cache', '/opt/graphite/conf/carbon.conf', ]
  $carbon_cache_httpd_subscribe  = ['/etc/sysconfig/httpd', '/etc/httpd/conf/httpd.conf', '/etc/httpd/conf.d/auth_kerb.conf', '/etc/httpd/conf.d/graphite.conf', '/etc/httpd/conf.d/ssl.conf', '/etc/pki/tls/private/localhost.key', '/etc/pki/tls/certs/localhost.crt', '/opt/graphite/webapp/graphite/local_settings.py', ]

  # Service defaults:
  Service {
    ensure => running,
    enable => true,
    hasrestart => true,
    hasstatus => true,
  }

  # Services
  service {
    'carbon-cache':
      hasrestart => false,
      hasstatus  => false,
      subscribe  => File[$carbon_cache_daemon_subscribe];
    'carbon-relay':
      ensure     => stopped,
      enable     => false;
    'httpd':
      ensure     => running,
      subscribe  => File[$carbon_cache_httpd_subscribe];
    'memcached':
      ensure     => stopped,
      enable     => false;
    'iptables':
      ensure     => stopped,
      enable     => false;
  }
}
