class kibana::install {
#  include gcc
#  if $kibana::rvm == true {
#    include rvm
#    rvm_system_ruby { 'ruby-2.0.0-p0-dev':
#      ensure      => present,
#      default_use => true;
#    }
#    rvm_gem { 'bundler':
#      ensure       => present,
#      ruby_version => 'ruby-2.0.0-p0-dev',
#      require      => Rvm_system_ruby['ruby-2.0.0-p0-dev'],
#      before       => Exec['bundler'],
#    }
#  } else {
#    class { 'ruby':
#      version         => 'latest',
#      gems_version    => 'latest',
#      rubygems_update => false,
#    }
#    include ruby::dev
#    include bundler
#  }

  class { 'apache': default_vhost => false, }

  include git

  file { $kibana::install_root: ensure => directory }
}

# vim: set ts=2 sw=2 et ft=puppet:
