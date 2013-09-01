#
class kibana::config {
  vcsrepo { $kibana::install_dir:
    ensure   => latest,
    provider => 'git',
    source   => 'git://github.com/elasticsearch/kibana.git',
    require  => Class['git'],
  }
#  exec { 'bundler':
#    command => 'bundle install',
#    path    => $::path,
#    cwd     => $kibana::install_dir,
#    unless  => 'bundle check',
#    require => [  Class['gcc'],
#                  Class['ruby::dev'],
#                  Class['bundler'],
#                  Vcsrepo[$kibana::install_dir]  ],
#    notify  => Exec['httpd-restart'],
#  }
#  file { "${kibana::install_dir}/KibanaConfig.rb":
#    ensure  => present,
#    content => template('kibana/KibanaConfig.erb'),
#    require => Vcsrepo[$kibana::install_dir],
#    notify  => Exec['httpd-restart'],
#  }

  file { "${kibana::install_dir}/dashboards/default.json":
    ensure => link,
    target => 'logstash.json',
  }

  apache::vhost { "${::fqdn}-kibana-vhost":
    port      => '80',
    ip        => $::ipaddress,
    ip_based  => true,
    docroot   => '/srv/www/kibana',
#    options  => [ '-Indexes', '-MultiViews' ],
#    override => [ 'None' ],
    require   => Vcsrepo[$kibana::install_dir],
  }
#  if $kibana::rvm == true {
#    class { 'rvm::passenger::apache':
#      version      => '4.0.2',
#      ruby_version => 'ruby-2.0.0-p0-dev',
#      mininstances => '3',
#      maxpoolsize  => '30',
#    }
#  } else {
#    include apache::mod::passenger
#  }

#  exec { 'httpd-restart':
#    command     => '/sbin/service httpd restart',
#    refreshonly => true,
#  }
}

# vim: ts=2 sw=2 et ft=puppet:
