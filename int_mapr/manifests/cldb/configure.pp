# Class: int_mapr::cldb::configure
#
# Actions:
#   Class for MapR CLDB configuration
#
class int_mapr::cldb::configure (
  $mapr_ensure_service = false,
) {

  if $mapr_ensure_service == true {
    service {
      'mapr-warden':
        ensure  => 'running',
    }
  }

}
