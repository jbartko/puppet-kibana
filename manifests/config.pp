class kibana::config {
  apache::vhost { $::fqdn:
    port     => '8080',
    docroot  => '/srv/www/kibana/public',
    options  => [ '-Indexes', '-MultiViews' ],
    override => 'None'
  }
}

# vim: ts=2 sw=2 et ft=puppet:
