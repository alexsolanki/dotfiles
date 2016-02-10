# Class: int_mapr::cldb::install
#
# Actions:
#   Class for installing MapR CLDB packages
#
class int_mapr::cldb::install (
  $mapr_version = undef,
) {

  # packages
  package {
    'mapr-fileserver':
      ensure => $mapr_version;
    'mapr-cldb':
      ensure => $mapr_version;
    'mapr-nfs':
      ensure => $mapr_version;
  }

}
