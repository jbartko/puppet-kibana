class kibana::install {
  include git

  class { 'apache': default_vhost => false, }

  file { $kibana::install_root: ensure => directory }
}

# vim: set ts=2 sw=2 et ft=puppet:
