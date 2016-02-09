# Class: int_mapr::install
#
# Actions:
#   Class for installing MapR cluster packages
#
class int_mapr::install {

  # TODO: Remove when /apps/bin is a thing
  $app_dirs = [
    '/apps',
    '/apps/bin',
    '/apps/etc',
  ]
  file { $app_dirs:
    ensure => directory,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  }

  # packages
  package {
    'python-argparse':
      ensure => installed;
    'python-facterpy':
      ensure => installed;
    'python-requests':
      ensure => installed;
    'cluster-validation':
      ensure => '1.0.0-1.rp6';
  }

  # files
  file {
    '/apps/bin/node-auditor.sh':
      source  => 'puppet:///modules/int_mapr/node-auditor.sh',
      mode    => '0755',
      require => File['/apps/bin'],;
    '/apps/bin/disk-failure-auditor.sh':
      source  => 'puppet:///modules/int_mapr/disk-failure-auditor.sh',
      mode    => '0755',
      require => File['/apps/bin'],;
    '/etc/cron.d/disk-failure-auditor':
      source  => 'puppet:///modules/int_mapr/disk-failure-auditor.cron';
  }

}
