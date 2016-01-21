# Class: int_pyramid::configure
#
# Actions:
#  Configuration class for pyramid webapp
#
class int_pyramid::configure (
  $project           = $::int_pyramid::params::project,
  $wsgi_dir          = $::int_pyramid::params::wsgi_dir,
) inherits int_pyramid::params {

  # If /apps is a standard, it should be in a default class somewhere.
  $app_dirs = [
    '/apps',
    "/apps/${project}_web",
    "/apps/${project}_web/conf"]
  $deploy_dirs = [
    "/apps/${project}_web/venv",
    "/apps/${project}_web/bin"
  ]

  file {
    '/etc/httpd/conf.d/wsgi.conf':
      ensure   => 'absent';
    $app_dirs :
      ensure => 'directory',
      owner  => 'apache',
      group  => 'apache',
      mode   => '0755';
    $deploy_dirs :
      ensure => 'directory',
      owner  => 'jenkins',
      group  => 'jenkins',
      mode   => '0755';
    "/apps/${project}_web/conf/${project}.wsgi":
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      content => template('int_pyramid/application.wsgi.erb');
    "/etc/httpd/conf.d/${project}-wsgi.conf":
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('int_pyramid/wsgi.conf.erb'),
      notify  => Service['httpd'];
    "/apps/${project}_web/conf/${project}_secrets.ini":
      ensure    => present,
      owner     => 'apache',
      group     => 'apache',
      mode      => '0600',
      show_diff => false,
      source    => "puppet:///private/common/int_pyramid/${project}_secrets.ini";
  }

  service { 'httpd':
    enable => true,
  }

}
