# Class: int_graphite::carbon_cache::prepare
#
# Actions:
#  Prepare environment for installation of graphite carbon-cache
#
class int_graphite::carbon_cache::prepare (
  $carbon_cache_ramdisk_mb = $::int_graphite::params::carbon_cache_ramdisk_mb
) inherits int_graphite::params {

  # Prepare and mount the ramdisk for whisper file storage
  file { '/ramdisk' :
      ensure => directory,
      owner  => root,
      group  => root,
      mode   => '0755',
  }
  mount { '/ramdisk' :
      ensure   => 'mounted',
      device   => 'tmpfs',
      name     => '/ramdisk',
      options  =>  "rw,size=${carbon_cache_ramdisk_mb}M,mode=0755",
      fstype   => 'tmpfs',
      remounts => true,
      dump     => '0',
      pass     => '0',
      require  => [ File['/ramdisk'], ],
  }
  file { '/ramdisk/whisper' :
      ensure  => directory,
      owner   => root,
      group   => root,
      mode    => '0755',
      require => [ Mount['/ramdisk'], ],
  }
}
