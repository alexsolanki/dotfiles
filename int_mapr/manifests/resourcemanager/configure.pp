# Class: int_mapr::resourcemanager::configure
#
# Actions:
#   Class for MapR Resource Manager conifguration
#
class int_mapr::resourcemanager::configure () {

  file {
    '/opt/mapr/adminuiapp/webapp/WEB-INF/jpamlogin.conf':
      content => 'puppet:///modules/int_mapr/resourcemanager/jpamlogin.conf',;
    '/opt/mapr/conf/mapr.login.conf':
      source => 'puppet:///modules/int_mapr/resourcemanager/mapr.login.conf',;
  }

}
