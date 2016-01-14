# Class: int_jmxtrans::configure
#
# Actions:
#  Configuration class for jmxtrans jvm monitoring
#
class int_jmxtrans::configure (
  $jmxtrans_port          = hiera('int_jmxtrans::jmxtrans_port'),
  $application            = hiera('int_jmxtrans::application'),
  $graphite_port          = hiera('int_jmxtrans::graphite_port'),
  $graphite_host          = hiera('int_jmxtrans::graphite_host'),
  $jmxtrans_beans         = hiera('int_jmxtrans::jmxtrans_beans'),
) {

  file {
    '/usr/share/jmxtrans/jmxtrans.sh':
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      source => 'puppet:///modules/int_jmxtrans/jmxtrans.sh',;
    '/etc/sysconfig/jmxtrans':
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      source => 'puppet:///modules/int_jmxtrans/sysconfig',
      notify => Service['jmxtrans'],;
    "/var/lib/jmxtrans/jmxtrans_${application}.json":
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
      content => template('int_jmxtrans/jmxtrans.json.erb'),
      notify => Service['jmxtrans'],;
  }->
  service { 'jmxtrans':
    ensure => running,
    enable => true,
  }

}
