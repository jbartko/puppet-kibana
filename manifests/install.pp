class kibana::install {
  # TODO: parameterize this
  $path = '/srv/www/kibana'

  # TODO: modulefile requires puppetlabs-git
  include git

  package { 'bundler':
    ensure   => latest,
    provider => 'gem',
  }

  # TODO: modulefile requires vcsrepo
  vcsrepo { $path:
    ensure   => present,
    provider => 'git',
    source   => 'git://github.com/rashidkpc/Kibana.git',
    revision => 'kibana-ruby',
    require  => Class['git'],
  }

  exec { 'bundler':
    command => "/usr/bin/bundle install",
    cwd     => $path,
    require => [ Vcsrepo[$path], Package['bundler'] ],
  }
}

# vim: set ts=2 sw=2 et ft=puppet:
