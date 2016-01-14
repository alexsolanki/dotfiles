# Class: int_pyramid::install
#
# Actions:
#  Install packages for pyramid webserver
#
class int_pyramid::install () inherits int_pyramid::params {


  $core_packages = ['mod_wsgi',
                    'python-virtualenv',
                    'python-devel',
                    'gcc',
                    'openldap-devel',
                    ]

  package { $core_packages :
      ensure => present,
  }

}
