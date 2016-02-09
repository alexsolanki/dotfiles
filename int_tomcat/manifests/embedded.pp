# Class: int_tomcat::embedded
#
# Actions:
#  Embedded tomcat core class
#
class int_tomcat::embedded (
  $app_name = hiera('int_tomcat::embedded::app_name'),
  $app_version = hiera('int_tomcat::embedded::app_version')
) {

  class { 'int_tomcat::embedded::install':
  }->
  class { 'int_tomcat::embedded::configure':
  }

}
