# manifests/resource/cert.pp

define catrust::resource::cert ( 
  String  $source,
  String  $fetch_unmodified = $::catrust::fetch_unmodified,
  String  $local_bin        = $::catrust::local_bin,
  String  $trust_dir        = $::catrust::trust_dir,
) {
  if ($source =~ /^puppet:\/\/\//) {
    file { "$trust_dir/$title.crt":
      ensure  => file,
      source  => $source,
      notify  => Exec['update_trust'],
    }
  } else {
    exec { "Fetch unmodified $title.crt":
      command => "$local_bin/$fetch_unmodified '$source' '$trust_dir/$title.crt'",
      creates => "$trust_dir/$title.crt",
      notify  => Exec['update_trust'],
      require => File["$local_bin/$fetch_unmodified"],
    }
  }
}

# vim: set ts=2 sw=2 et syn=puppet:
