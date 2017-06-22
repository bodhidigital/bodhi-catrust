# manifests/package.pp

# For internal use only!

class catrust::package (
  Boolean $manage_curl  = $::catrust::manage_curl,
  Boolean $manage_bash  = $::catrust::manage_bash,
  String  $curl_package = $::catrust::curl_package,
  String  $bash_package = $::catrust::bash_package,
) {
  if ($manage_curl) {
    package { "$curl_package":
      ensure  => latest,
    }
  }
  if ($manage_bash) {
    package { "$bash_package":
      ensure  => latest,
    }
  }
}

# vim: set ts=2 sw=2 et syn=puppet:
