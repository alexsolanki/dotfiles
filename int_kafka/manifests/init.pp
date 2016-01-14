# Class: int_kafka
#
# Actions:
#  Base class for Kafka message broker
#
class int_kafka () {

  class { 'int_kafka::install':
  }->
  class { 'int_kafka::configure':
  }

}
