# Class: int_jre::install
#
# Actions:
#  Install packages for the jre
#
class int_jre::install (
  $jre_version = hiera('int_jre::jre_version')
) {

  package { 'jre' :
      ensure => $jre_version,
  }

}
