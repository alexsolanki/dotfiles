# class: int_mapr::validate
#
# Actions:
#   Class for validating a MapR node
#
# Requires:
#   int_mapr::buildconf
#
class int_mapr::validate {

  # Run validation
  exec { 'validate_node':
    command => '/apps/bin/node-auditor.sh -m all > /opt/trp/cluster-validation/logs/node-auditor.out 2>&1 &',
    creates => [
      '/opt/trp/cluster-validation/logs/validation_runounce',
      '/var/run/node-auditor.pid',
    ],
    require => File['/apps/bin/mapr_configure_command'],
  }

}
