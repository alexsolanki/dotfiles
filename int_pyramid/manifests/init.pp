# Class: int_pyramid
#
# Actions:
#  Base class for pyramid webapps
#
class int_pyramid () inherits int_pyramid::params {

  class { 'int_pyramid::install':
  }->
  class { 'int_pyramid::configure':
  }

}
