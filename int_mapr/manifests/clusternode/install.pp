# Class: int_mapr::clusternode::install
#
# Actions: Class to install MapR cluster node packages
#
class int_mapr::clusternode::install (
  $mapr_version = undef,
  $mapreduce_version = undef,
) {

  # packages
  package {
    'mapr-fileserver':
      ensure => $mapr_version;
    'mapr-nodemanager':
      ensure => $mapreduce_version;
  }

}
