class kibana::service {
  service { 'httpd':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
  }
}

# vim: set ts=2 sw=2 et ft=puppet:
