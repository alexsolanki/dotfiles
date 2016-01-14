# Class: int_jmxtrans
#
# Actions:
#  Base class for jmxtrans jvm monitoring
#
class int_jmxtrans () {

  class { 'int_jmxtrans::install':
  }->
  class { 'int_jmxtrans::configure':
  }

}
