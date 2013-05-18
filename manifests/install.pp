class kibana::install {
  # TODO: modulefile requires puppetlabs-git
  include git

  vcsrepo { '/srv/www/kibana':
    ensure   => present,
    provider => 'git',
    source   => 'git://github.com/rashidkpc/Kibana.git',
    revision => 'kibana-ruby',
  }

#  bundler::install { '/srv/www/kibana': require => Vcsrepo['/srv/www/kibana'] }
}

# vim: set ts=2 sw=2 et ft=puppet:
