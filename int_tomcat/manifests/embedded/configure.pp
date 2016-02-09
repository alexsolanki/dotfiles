# Class: int_tomcat::embedded::configure
#
# Actions:
#  Configure embedded tomcat
#
class int_tomcat::embedded::configure (
  $app_name = $int_tomcat::embedded::app_name
) inherits int_tomcat::embedded {

  $tomcat_dirs = [
    "/apps/${app_name}/conf",
    "/apps/${app_name}/log",
  ]

  file {
    $tomcat_dirs:
      ensure => directory,
      owner  => 'prodicon',
      group  => 'prodicon',
      mode   => '0755',;
    "/apps/${app_name}/${app_name}.conf":
      owner   => 'prodicon',
      group   => 'prodicon',
      mode    => '0644',
      content => template('int_tomcat/embedded/spring.conf.erb'),
      notify  => Service["${app_name}"],;
    "/etc/init.d/${app_name}":
      ensure => link,
      target => "/apps/${app_name}/${app_name}.jar",;
  }->
  service { "${app_name}":
    enable => true,
  }

}
