# Class: int_graphite::carbon_cache
#
# Actions:
#  Class for graphite carbon_cache
#
class int_graphite::carbon_cache () inherits int_graphite::params {

  class { 'int_graphite::carbon_cache::prepare':
  }->
  class { 'int_graphite::carbon_cache::install':
  }->
  class { 'int_graphite::carbon_cache::configure':
  }->
  class { 'int_graphite::carbon_cache::runtime':
  }

}
