# manifests/resource/crl.pp

define catrust::resource::crl ( 
  String  $source,
  Integer $crl_interval     = $::catrust::crl_interval,
  String  $fetch_unmodified = $::catrust::fetch_unmodified,
  String  $local_bin        = $::catrust::local_bin,
  String  $trust_dir        = $::catrust::trust_dir,
  String  $ca_update        = $::catrust::ca_update,
) {
  if ($source =~ /^puppet:\/\/\//) {
    file { "$trust_dir/$title.crl":
      ensure  => file,
      source  => $source,
      notify  => Exec['update_trust'],
    }
  } else {
    exec { "Fetch unmodified $title.crl":
      command => "$local_bin/$fetch_unmodified '$source' '$trust_dir/$title.crl'",
      creates => "$trust_dir/$title.crl",
      notify  => Exec['update_trust'],
      require => File["$local_bin/$fetch_unmodified"],
    }
    cron { "Update unmodified $title.crl":
      command => "$local_bin/$fetch_unmodified '$source' '$trust_dir/$title.crl' '$ca_update'",
      minutes => [ $crl_interval ],
      require => File["$local_bin/$fetch_unmodified"],
    }
  }
}

# vim: set ts=2 sw=2 et syn=puppet:
