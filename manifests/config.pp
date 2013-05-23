class kibana::config {
  apache::vhost { $::fqdn:
    port     => '8080',
    docroot  => '/srv/www/kibana/public',
    options  => [ '-Indexes', '-MultiViews' ],
    override => 'None'
  }
  if $kibana::rvm == true {
    class { 'rvm::passenger::apache':
      version      => '4.0.2',
      ruby_version => 'ruby-2.0.0-p0-dev',
      mininstances => '3',
      maxpoolsize  => '30',
    }
  } else {
    include apache::mod::passenger
  }
}
Class['kibana::config'] ~> Service['httpd']

# vim: ts=2 sw=2 et ft=puppet:
