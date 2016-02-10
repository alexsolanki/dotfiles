# Class: int_tomcat::embedded::install
#
# Actions:
#  Install embedded tomcat
#
class int_tomcat::embedded::install (
  $app_name = $int_tomcat::embedded::app_name,
) inherits int_tomcat::embedded {

  package { $app_name:
    ensure => $::int_tomcat_embedded_app_version,
    notify  => Service["${app_name}"],;
  }

}
