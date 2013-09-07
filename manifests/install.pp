class kibana::install {
  include git

  class { 'apache':
    default_vhost => false,
    purge_configs => false,
  }
  if $kibana::ldap_enable != false {
    ensure_packages([ 'mod_authz_ldap' ])
  }

  file { $kibana::install_root: ensure => directory }
}

# vim: set ts=2 sw=2 et ft=puppet:
