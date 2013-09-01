class kibana::install {
  if $kibana::rvm == true {
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
  } else {
    class { 'ruby':
      version         => 'latest',
      gems_version    => 'latest',
      rubygems_update => false,
    }
  }

  class { 'apache': default_vhost => false, }

  include git

  file { $kibana::install_root: ensure => directory }

  vcsrepo { $kibana::install_dir:
    ensure   => latest,
    provider => 'git',
    source   => 'git://github.com/rashidkpc/Kibana.git',
    revision => 'kibana-ruby',
    require  => Class['git'],
  }

  exec { 'bundler':
    command => 'bundle install',
    path    => $::path,
    cwd     => $kibana::install_dir,
    unless  => 'bundle check',
    require => [ Vcsrepo[$kibana::install_dir] ],
  }
}

# dirty dirty systemruby hack
#class bundler {
#  package { 'bundler':
#    ensure   => latest,
#    provider => 'gem',
#    require  => Class['ruby'],
#    before   => Exec['bundler'],
#  }
#}
# Warning: puppet abuse!

# vim: set ts=2 sw=2 et ft=puppet:
