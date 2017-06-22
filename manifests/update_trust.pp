# manifests/update_trust.pp

# For internal use only!

class catrust::update_trust (
  String  $ca_update  = $::catrust::ca_update,
) {
  exec { 'update_trust':
    command     => "/usr/bin/env $ca_update",
    refreshonly => true,
  }
}

# vim: set ts=2 sw=2 et syn=puppet:
