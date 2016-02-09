# Class: int_tomcat::embedded::install
#
# Actions:
#  Install embedded tomcat
#
class int_tomcat::embedded::install (
  $app_name = $int_tomcat::embedded::app_name,
  $app_version = $int_tomcat::embedded::app_version,
) inherits int_tomcat::embedded {

  class {
    'int_jre':
  }->
  class {
    'prodicon-user':
  }->
  package { $app_name:
    ensure => $app_version,
  }

}
