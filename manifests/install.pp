class kibana::install {
  # TODO: parameterize this
  $dir = '/srv/www/kibana'

  # TODO: modulefile requires puppetlabs-ruby
  class { 'ruby':
    version         => 'latest',
    gems_version    => 'latest',
    rubygems_update => false,
  }

  # TODO: modulefile requires puppetlabs-git
  include git

  package { 'bundler':
    ensure   => latest,
    provider => 'gem',
    require  => Class['ruby'],
  }

  # TODO: modulefile requires vcsrepo
  vcsrepo { $dir:
    ensure   => present,
    provider => 'git',
    source   => 'git://github.com/rashidkpc/Kibana.git',
    revision => 'kibana-ruby',
    require  => Class['git'],
  }

  exec { 'bundler':
    command => "bundle install",
    path    => $::path,
    cwd     => $dir,
    require => [ Vcsrepo[$dir], Package['bundler'] ],
  }
}

# vim: set ts=2 sw=2 et ft=puppet:
