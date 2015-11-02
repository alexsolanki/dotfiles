class int_graphite::params {

  $local_cache    = hiera("int_graphite::params::local_cache")
  $remote_cache   = hiera("int_graphite::params::remote_cache")
  $port_start     = hiera("int_graphite::params::port_start")
  $port_end       = hiera("int_graphite::params::port_end")

}
