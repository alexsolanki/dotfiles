# Class: int_kafka::configure
#
# Actions:
#  Configuration class for Kafka message broker
#
class int_kafka::configure (
  $data_dir          = hiera('int_kafka::data_dir'),
  $zookeeper_servers = hiera('int_kafka::zookeeper_servers')
) {

  file {
    $data_dir :
      ensure => 'directory',
      owner  => 'kafka',
      group  => 'kafka',
      mode   => '0755';
    '/etc/kafka/server.properties':
      owner   => 'kafka',
      group   => 'kafka',
      mode    => '0644',
      content => template('int_kafka/server.properties.erb'),;
    '/etc/kafka/kafka-env.sh':
      owner   => 'kafka',
      group   => 'kafka',
      mode    => '0755',
      source => 'puppet:///modules/int_kafka/kafka-env.sh',;
  }->
  service { 'kafka':
    ensure => running,
    enable => true,
  }

}
