# Class: int_tomcat::embedded::install
#
# Actions:
#  Install embedded tomcat
#
class int_tomcat::embedded::install (
  $app_version = $int_tomcat::embedded::app_version
) inherits int_tomcat::embedded {

  class {
    'int_jre':
  }->
  class {
    'prodicon-user':
  }->
  package { 'platform-system-config':
    ensure => $app_version,
  }->

}
