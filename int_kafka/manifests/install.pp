# Class: int_kafka::install
#
# Actions:
#  Install packages for the Kafka message broker.
#
class int_kafka::install (
  $kafka_version = hiera('int_kafka::kafka_version')
) {

  package { 'kafka' :
      ensure => $kafka_version,
  }

}
