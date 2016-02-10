# Class: int_mapr::configure
#
# Actions:
#   Class for MapR cluster configuration
#
class int_mapr::configure {

  # MapR specific users and groups
  group { 'shadow':
    ensure => present,
    gid    => 803,
  }

  user { 'mapr':
    ensure     => present,
    comment    => 'MapR user',
    gid        => 'mapr',
    groups     => 'shadow',
    home       => '/opt/mapr',
    managehome => false,
    shell      => '/bin/bash',
    uid        => 800,
    require    => Group[ 'shadow' ],
  }

  user { 'maprapi':
    ensure     => present,
    comment    => 'MapR API user',
    gid        => 'maprapi',
    home       => '/home/maprapi',
    managehome => true,
    shell      => '/bin/bash',
    uid        => 805,
  }

}
