# manifests/init.pp

class catrust (
  Boolean $manage_curl      = true,
  Boolean $manage_bash      = false,
  Integer $crl_interval     = 5,
  Hash    $catrust_certs    = {},
  Hash    $catrust_crls     = {},
) inherits ::nginx::params {
  contain '::catrust::package'
  contain '::catrust::fetch_unmodified'
  contain '::catrust::update_trust'

  create_resources('::catrust::resource::cert', $catrust_certs)
  create_resources('::catrust::resource::crl',  $catrust_crls)
}

# vim: set ts=2 sw=2 et syn=puppet:
