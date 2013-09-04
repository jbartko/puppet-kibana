#
class kibana::params {
  $es_host      = 'localhost'
  $es_port      = '9200'
  $install_root = '/srv/www'
  $version      = 'v3.0.0milestone3'
}

# vim: set ts=2 sw=2 et ft=puppet:
