# Class: int_graphite::carbon_cache::install
#
# Actions:
#  Install packages for graphite carbon-cache
#
class int_graphite::carbon_cache::install (
  $carbon_cache_package_requires = $::int_graphite::params::carbon_cache_package_requires,
  $carbon_cache_packages         = $::int_graphite::params::carbon_cache_packages,
  $carbon_cache_version          = $::int_graphite::params::carbon_cache_version
  
) inherits int_graphite::params {

  package { $carbon_cache_package_requires :
      ensure  => present,
  }
  package { $carbon_cache_packages :
      ensure  => $carbon_cache_version,
      require => Package[$carbon_cache_package_requires],
  }

}
