# Class: int_mapr::resourcemanager::install
#
# Actions: Class for installing MapR Resource Manager packages
#
class int_mapr::resourcemanager::install (
  $mapr_version = undef,
  $mapreduce_version = undef,
) {

  # packages
  package {
    'mapr-fileserver':
      ensure => $mapr_version;
    'mapr-webserver':
      ensure => $mapr_version;
    'mapr-gateway':
      ensure => $mapr_version;
    'mapr-resourcemanager':
      ensure => $mapreduce_version;
    'mapr-historyserver':
      ensure => $mapreduce_version;
  }

}
