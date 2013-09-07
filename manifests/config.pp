#
class kibana::config {
  vcsrepo { $kibana::install_dir:
    ensure   => present,
    revision => $kibana::version,
    provider => 'git',
    source   => 'git://github.com/elasticsearch/kibana.git',
    require  => Class['git'],
  }

  file { "${kibana::install_dir}/config.js":
    ensure  => present,
    content => template('kibana/config.erb'),
  }

  file { "${kibana::install_dir}/dashboards/default.json":
    ensure => link,
    target => 'logstash.json',
  }

  if $kibana::ldap_enable != false {
    apache::vhost { "${::fqdn}-kibana-vhost":
      port            => '80',
      ip              => $::ipaddress,
      ip_based        => true,
      docroot         => '/srv/www/kibana',
      custom_fragment => template($kibana::ldap_enable),
      require         => Vcsrepo[$kibana::install_dir],
    }
  }
  else {
    apache::vhost { "${::fqdn}-kibana-vhost":
      port     => '80',
      ip       => $::ipaddress,
      ip_based => true,
      docroot  => '/srv/www/kibana',
      require  => Vcsrepo[$kibana::install_dir],
    }
  }
}

# vim: ts=2 sw=2 et ft=puppet:
