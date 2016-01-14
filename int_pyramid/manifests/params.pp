# Class: int_pyramid::params
#
# Actions:
#  Params class for int_pyramid
#
class int_pyramid::params {

  $project           = hiera('int_pyramid::params::project')
  $wsgi_dir          = hiera('int_pyramid::params::wsgi_dir')

}
