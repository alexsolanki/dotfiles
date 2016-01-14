# Class: int_zookeeper::configure
#
# Actions:
#  Configuration class for Zookeeper
#
class int_zookeeper::configure (
  $data_dir                = hiera('int_zookeeper::data_dir'),
  $zookeeper_servers       = hiera('int_zookeeper::zookeeper_servers'),
) {

  file {
    $data_dir :
      ensure => 'directory',
      owner  => 'zookeeper',
      group  => 'zookeeper',
      mode   => '0755';
    '/etc/zookeeper/zoo.cfg':
      owner   => 'zookeeper',
      group   => 'zookeeper',
      mode    => '0644',
      content => template('int_zookeeper/zoo.cfg.erb'),;
    "${data_dir}/myid":
      owner   => 'zookeeper',
      group   => 'zookeeper',
      mode    => '0644',
      content => template('int_zookeeper/myid.erb'),;
  }->
  service { 'zookeeper':
    ensure => running,
    enable => true,
  }

}
