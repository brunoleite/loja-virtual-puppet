class loja_virtual::repo($basedir, $param_name) {
  package { 'reprepro':
    ensure => 'installed',
  }

  $repo_structure = [
    "$basedir",
    "$basedir/conf",
  ]

  file { $repo_structure:
    ensure => 'directory',
    owner  => 'jenkins',
    group  => 'jenkins',
    require => Class['jenkins'],
  }

  file { "$basedir/conf/distributions":
    owner  => 'jenkins',
    group  => 'jenkins',
    content => template('loja_virtual/distributions.erb'),
    require => File["$basedir/conf"],
  }

  class { 'apache': }

  apache::vhost { $param_name:
    port => 80,
    docroot => $basedir,
    servername => $facts['networking']['interfaces']['eth1']['ip'],
  }
}
