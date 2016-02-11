# Class: int_mapr::cldb
#
# Actions: Base class for MapR CLDB
#
class int_mapr::cldb (
  $mapr_version = undef,
) {

  class { 'int_mapr::cldb::install':
    mapr_version      => $mapr_version,
  }->
  class { 'int_mapr::cldb::configure':
  }

}
