# manifests/params.pp

# For internal use only!
#
class catrust::params {
  $curl_package = 'curl'
  $bash_package = 'bash'
  $fetch_unmodified = 'fetch-unmodified'
  $local_bin = '/usr/local/bin'

  case "$::osfamily" {
    'Debian': {
      $trust_dir = '/usr/local/share/ca-certificates'
      $ca_update = '/usr/sbin/update-ca-certificates'
    }
    'ArchLinux': {
      $trust_dir = '/etc/ca-certificates/trust-source/anchors'
      $ca_update = '/usr/bin/update-ca-trust'
    }
  }
}

# vim: set ts=2 sw=2 et syn=puppet:
