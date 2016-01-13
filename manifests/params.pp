# Class: int_graphite::params
#
# Actions:
#  Params class for int_graphite
#
class int_graphite::params {

  $local_cache             = hiera('int_graphite::params::local_cache')
  $remote_cache            = hiera('int_graphite::params::remote_cache')
  $port_start              = hiera('int_graphite::params::port_start')
  $port_end                = hiera('int_graphite::params::port_end')
  $carbon_c_relay_state    = hiera('int_graphite::params::carbon_c_relay_state')
  $carbon_c_relay_enable   = hiera('int_graphite::params::carbon_c_relay_enable')
  $carbon_cache_ramdisk_mb = hiera('int_graphite::params::carbon_cache_ramdisk_mb')

  # OS-based variables (see hieradata/operatingsystem)
  $carbon_cache_version          = hiera('int_graphite::params::carbon_cache_version')
  $carbon_cache_package_requires = hiera('int_graphite::params::carbon_cache_package_requires')
  $carbon_cache_packages         = hiera('int_graphite::params::carbon_cache_packages')

  # Resource arrays
  $carbon_cache_daemon_subscribe = ['/opt/graphite/conf/storage-aggregation.conf', '/opt/graphite/conf/storage-schemas.conf', '/etc/security/limits.d/graphite_storage.conf', '/etc/init.d/carbon-cache', '/opt/graphite/conf/carbon.conf', ]
  $carbon_cache_httpd_subscribe  = ['/etc/sysconfig/httpd', '/etc/httpd/conf/httpd.conf', '/etc/httpd/conf.d/auth_kerb.conf', '/etc/httpd/conf.d/graphite.conf', '/etc/httpd/conf.d/ssl.conf', '/etc/pki/tls/private/localhost.key', '/etc/pki/tls/certs/localhost.crt', '/opt/graphite/webapp/graphite/local_settings.py', ]

}
