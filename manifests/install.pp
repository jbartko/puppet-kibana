class kibana::install {
  if $kibana::rvm == true {
    # TODO: modulefile requires blt04-rvm
    include rvm
    rvm_system_ruby { 'ruby-2.0.0-p0': ensure => present, default_use => true;
                      'ruby-2.0.0-p0-dev': ensure => present, }
    rvm_gem { 'bundler':
      ensure       => present,
      ruby_version => 'ruby-2.0.0-p0',
      require      => Rvm_system_ruby['ruby-2.0.0-p0'],
      before       => Exec['bundler'],
    }
    # rvm::system_user { [ 'jbartko' ]: }
  } else {
    # TODO: modulefile requires puppetlabs-ruby
    class { 'ruby':
      version         => 'latest',
      gems_version    => 'latest',
      rubygems_update => false,
    }

  }

  # TODO: parameterize this
  $dir = '/srv/www/kibana'

  class { 'apache': default_vhost => false, }

  # TODO: modulefile requires puppetlabs-git
  include git

  # TODO: modulefile requires vcsrepo
  vcsrepo { $dir:
    ensure   => present,
    provider => 'git',
    source   => 'git://github.com/rashidkpc/Kibana.git',
    revision => 'kibana-ruby',
    require  => Class['git'],
  }

  exec { 'bundler':
    command => 'bundle install',
    path    => $::path,
    cwd     => $dir,
    unless  => 'bundle check',
    require => [ Vcsrepo[$dir] ],
  }
}

# dirty dirty systemruby hack
class bundler {
  package { 'bundler':
    ensure   => latest,
    provider => 'gem',
    require  => Class['ruby'],
    before   => Exec['bundler'],
  }
}
# Warning: puppet abuse!

# vim: set ts=2 sw=2 et ft=puppet:
