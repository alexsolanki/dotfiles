# Class: int_jmxtrans::install
#
# Actions:
#  Install packages for the jmxtrans jvm monitor
#
class int_jmxtrans::install (
  $jmxtrans_version = hiera('int_jmxtrans::jmxtrans_version')
) {

  package { 'jmxtrans' :
      ensure => $jmxtrans_version,
  }

}
