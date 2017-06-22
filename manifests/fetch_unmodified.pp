# manifests/fetch_unmodified.pp

# For internal use only!

class catrust::fetch_unmodified (
  String  $fetch_unmodified = $::catrust::fetch_unmodified,
  String  $local_bin        = $::catrust::local_bin,
) {
  file { "$local_bin/$fetch_unmodified":
    ensure  => file,
    source  => "puppet:///modules/$module_name/fetch-unmodified.sh",
    mode    => '0755',
  }
}

# vim: set ts=2 sw=2 et syn=puppet:
