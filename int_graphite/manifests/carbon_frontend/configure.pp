# Class: int_graphite::carbon_frontend::configure
#
# Actions:
#  Configuration class for graphite carbon-frontend
#
class int_graphite::carbon_frontend::configure () inherits int_graphite::params {

  # Variables (Using carbon-cache values, which are OS-based, for sysconfig)
  $carbon_cache_httpd_sysconfig_state = hiera('int_graphite::params::carbon_cache_httpd_sysconfig_state')
  $carbon_frontend_memcached_size     = hiera('int_graphite::params::carbon_frontend_memcached_size')
  $carbon_frontend_httpd_maxclients   = hiera('int_graphite::params::carbon_frontend_httpd_maxclients')

  # File resource defaults
  File {
      owner   => root,
      group   => root,
      mode    => 644,
  }

  # Files: Logs and storage (directories / links)
  file {
    '/opt/graphite/storage':
      owner => 'apache',
      group => 'apache';
    '/opt/graphite/storage/log/webapp':
      owner => 'apache',
      group => 'apache';
    '/opt/graphite/storage/whisper':
      owner => 'apache',
      group => 'apache';
  }

  # Files: Configuration (static)
  file {
    '/etc/sysconfig/httpd':
      ensure  => $carbon_cache_httpd_sysconfig_state,
      source  => 'puppet:///modules/int_graphite/carbon_frontend/sysconfig.httpd';
    '/etc/httpd/conf.d/auth_kerb.conf':
      source  => 'puppet:///modules/int_graphite/carbon_frontend/auth_kerb.conf';
    '/etc/httpd/conf.d/graphite.conf':
      source  => 'puppet:///modules/int_graphite/carbon_frontend/graphite.conf';
    '/opt/graphite/conf/carbon.conf':
      source  => 'puppet:///modules/int_graphite/carbon_frontend/carbon.conf';
    '/opt/graphite/conf/dashboard.conf':
      source  => 'puppet:///modules/int_graphite/carbon_frontend/dashboard.conf';
    '/opt/graphite/conf/graphTemplates.conf':
      source  => 'puppet:///modules/int_graphite/carbon_frontend/graphTemplates.conf';
    '/opt/graphite/webapp/graphite/local_settings.py':
      source  => 'puppet:///modules/int_graphite/carbon_frontend/local_settings.py';
    '/etc/logrotate.d/httpd':
      source  => 'puppet:///modules/int_graphite/carbon_frontend/httpd.logrotate';
    '/etc/security/limits.d/carbon_frontend.conf':
      source  => 'puppet:///modules/int_graphite/carbon_frontend/carbon_frontend.conf.limits';
  }

  # Files: SSL configuration (static)
  file {
    '/etc/httpd/conf.d/ssl.conf':
      ensure    => present;
    '/etc/pki/tls/private/localhost.key':
      mode      => '0600',
      owner     => 'root',
      group     => 'root',
      show_diff => false;
    '/etc/pki/tls/certs/localhost.crt':
      mode      => '0600',
      owner     => 'root',
      group     => 'root',
      show_diff => false;
  }

  # Files: Templated configurations (dynamic)
  file {
    '/etc/sysconfig/memcached':
      content   => template('int_graphite/carbon_frontend/memcached.erb');
    '/etc/httpd/conf/httpd.conf':
      content   => template('int_graphite/carbon_frontend/httpd.conf.erb');
  }

}
