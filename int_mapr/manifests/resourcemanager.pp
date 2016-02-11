# Class: int_mapr::resourcemanager
#
# Actions: Base class for MapR Resource Manager
#
class int_mapr::resourcemanager (
  $mapr_version = undef,
  $mapreduce_version = undef,
) {

  class { 'int_mapr::resourcemanager::install':
    mapr_version      => $mapr_version,
    mapreduce_version => $mapreduce_version,
  }->
  class { 'int_mapr::resourcemanager::configure':
  }

}
