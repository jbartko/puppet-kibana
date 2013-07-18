class kibana::install {
  if $kibana::rvm_real == true {
    # TODO: modulefile requires blt04-rvm
    include rvm
    rvm_system_ruby { 'ruby-2.0.0-p0-dev':
      ensure      => present,
      default_use => true;
    }
    rvm_gem { 'bundler':
      ensure       => present,
      ruby_version => 'ruby-2.0.0-p0-dev',
      require      => Rvm_system_ruby['ruby-2.0.0-p0-dev'],
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

  class { 'apache': default_vhost => false, }

  # TODO: modulefile requires puppetlabs-git
  include git

  file { $kibana::install_dir_real: ensure => directory }

  # TODO: modulefile requires vcsrepo
  vcsrepo { $kibana::install_dir_real:
    ensure   => present,
    provider => 'git',
    source   => 'git://github.com/rashidkpc/Kibana.git',
    revision => 'kibana-ruby',
    require  => Class['git'],
  }

  exec { 'bundler':
    command => 'bundle install',
    path    => $::path,
    cwd     => $kibana::install_dir_real,
    unless  => 'bundle check',
    require => [ Vcsrepo[$kibana::install_dir_real] ],
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
