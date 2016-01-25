# Class: int_graphite::carbon_frontend::runtime
#
# Actions:
#  Runtime management for graphite carbon-frontend
#
class int_graphite::carbon_frontend::runtime () inherits int_graphite::params {

  # Variables
  $carbon_frontend_httpd_subscribe  = ['/etc/sysconfig/httpd', '/etc/httpd/conf/httpd.conf', '/etc/httpd/conf.d/auth_kerb.conf', '/etc/httpd/conf.d/graphite.conf', '/etc/pki/tls/private/localhost.key', '/etc/pki/tls/certs/localhost.crt', '/opt/graphite/webapp/graphite/local_settings.py', ]

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
      ensure     => stopped,
      hasrestart => false,
      hasstatus  => false,
      enable     => false;
    'carbon-relay':
      ensure     => stopped,
      hasrestart => false,
      hasstatus  => false,
      enable     => false;
    'httpd':
      ensure     => running,
      subscribe  => File[$carbon_frontend_httpd_subscribe],
      enable     => true;
    'memcached':
      ensure     => running,
      enable     => true;
    'iptables':
      ensure     => stopped,
      enable     => false;
  }
}
