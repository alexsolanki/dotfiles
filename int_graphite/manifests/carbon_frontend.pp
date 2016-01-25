# Class: int_graphite::carbon_frontend
#
# Actions:
#  Class for graphite carbon_frontend (carbon packages + httpd + configuration)
#
class int_graphite::carbon_frontend () inherits int_graphite::params {

  class { 'int_graphite::carbon_frontend::install':
  }->
  class { 'int_graphite::carbon_frontend::configure':
  }->
  class { 'int_graphite::carbon_frontend::runtime':
  }

}
