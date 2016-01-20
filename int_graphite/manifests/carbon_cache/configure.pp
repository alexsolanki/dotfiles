# Class: int_graphite::carbon_cache::configure
#
# Actions:
#  Configuration class for graphite carbon-cache
#
class int_graphite::carbon_cache::configure () inherits int_graphite::params {

  # Variables
  $carbon_cache_httpd_sysconfig_state = hiera('int_graphite::params::carbon_cache_httpd_sysconfig_state')
  $carbon_cache_httpd_maxclients      = hiera('int_graphite::params::carbon_cache_httpd_maxclients')

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
      ensure   => link,
      force    => true,
      target   => '/ramdisk/whisper';
  }

  # Files: Configuration (static)
  file {
    '/etc/sysconfig/httpd':
      ensure  => $carbon_cache_httpd_sysconfig_state,
      source  => 'puppet:///modules/int_graphite/carbon_cache/sysconfig.httpd';
    '/etc/httpd/conf.d/auth_kerb.conf':
      source  => 'puppet:///modules/int_graphite/carbon_cache/auth_kerb.conf';
    '/etc/httpd/conf.d/graphite.conf':
      source  => 'puppet:///modules/int_graphite/carbon_cache/graphite.conf';
    '/etc/rsyncd.conf':
      source  => 'puppet:///modules/int_graphite/carbon_cache/rsyncd.conf';
    '/opt/graphite/conf/storage-aggregation.conf':
      source  => 'puppet:///modules/int_graphite/carbon_cache/storage-aggregation.conf';
    '/opt/graphite/conf/aggregation-rules.conf':
      source  => 'puppet:///modules/int_graphite/carbon_cache/aggregation-rules.conf';
    '/opt/graphite/conf/dashboard.conf':
      source  => 'puppet:///modules/int_graphite/carbon_cache/dashboard.conf';
    '/opt/graphite/conf/graphTemplates.conf':
      source  => 'puppet:///modules/int_graphite/carbon_cache/graphTemplates.conf';
    '/opt/graphite/conf/rewrite-rules.conf':
      source  => 'puppet:///modules/int_graphite/carbon_cache/rewrite-rules.conf';
    '/opt/graphite/conf/storage-schemas.conf':
      source  => 'puppet:///modules/int_graphite/carbon_cache/storage-schemas.conf';
    '/etc/init.d/carbon-relay':
      mode    => '0755',
      source  => 'puppet:///modules/int_graphite/carbon_cache/carbon-relay.init';
    '/etc/sysconfig/memcached':
      source  => 'puppet:///modules/int_graphite/carbon_cache/memcached',
      notify  => Service['memcached'];
    '/etc/logrotate.d/httpd':
      source  => 'puppet:///modules/int_graphite/carbon_cache/httpd.logrotate';
    '/etc/security/limits.d/graphite_storage.conf':
      source  => 'puppet:///modules/int_graphite/carbon_cache/graphite_storage.conf.limits';
  }

  # Files: Backup scripts and related scripts (static)
  file {
    '/opt/graphite/bin/graphite-metric-bulk-create':
      mode    => '0755',
      source  => 'puppet:///modules/int_graphite/carbon_cache/graphite-metric-bulk-create';
    '/opt/graphite/bin/graphite-metric-lister':
      mode    => '0755',
      source  => 'puppet:///modules/int_graphite/carbon_cache/graphite-metric-lister';
    '/opt/graphite/bin/whisper-cleanup.sh':
      mode    => '0755',
      source  => 'puppet:///modules/int_graphite/carbon_cache/whisper-cleanup.sh';
    '/opt/graphite/bin/backgraph.sh':
      mode    => '0755',
      source  => 'puppet:///modules/int_graphite/carbon_cache/backgraph.sh';
    '/opt/graphite/bin/carbon-babysitter':
      mode    => '0755',
      source  => 'puppet:///modules/int_graphite/carbon_cache/carbon-babysitter';
    '/etc/cron.d/backgraph':
      source  => 'puppet:///modules/int_graphite/carbon_cache/backgraph.cron';
    '/etc/cron.d/cleangraph':
      source  => 'puppet:///modules/int_graphite/carbon_cache/cleangraph.cron';
  }

  # Files: SSL configuration (static)
  file {
    '/etc/httpd/conf.d/ssl.conf':
      source    => 'puppet:///modules/int_graphite/carbon_cache/ssl.conf';
    '/etc/pki/tls/private/localhost.key':
      mode      => '0600',
      owner     => 'root',
      group     => 'root',
      show_diff => false,
      source    => 'puppet:///private/common/keys/graphite_storage_localhost.key';
    '/etc/pki/tls/certs/localhost.crt':
      mode      => '0600',
      owner     => 'root',
      group     => 'root',
      show_diff => false,
      source    => 'puppet:///private/common/certs/graphite_storage_localhost.crt';
  }

  # Files: Templated configurations (dynamic)
  file {
    '/etc/httpd/conf/httpd.conf':
      content   => template('int_graphite/carbon_cache/httpd.conf.erb');
    '/etc/init.d/carbon-cache':
      mode      => '0755',
      content   => template('int_graphite/carbon_cache/carbon-cache.erb');
    '/opt/graphite/conf/carbon.conf':
      content   => template('int_graphite/carbon_cache/carbon.conf.erb');
    '/opt/graphite/webapp/graphite/local_settings.py':
      content   => template('int_graphite/carbon_cache/local_settings.py.erb');
  }

}
