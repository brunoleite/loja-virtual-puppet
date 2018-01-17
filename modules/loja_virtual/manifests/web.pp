class loja_virtual::web {
  include loja_virtual
  include mysql::client
  include loja_virtual::params

  file { $loja_virtual::params::keystore_file:
    mode    => "0644",
    source  => "puppet:///modules/loja_virtual/.keystore",
  }

  class { "tomcat::server":
    connectors => [$loja_virtual::params::ssl_connector],
    data_sources => {
      "jdbc/web"      => $loja_virtual::params::db,
      "jdbc/secure"   => $loja_virtual::params::db,
      "jdbc/storage"  => $loja_virtual::params::db,
    },
    require => File[$loja_virtual::params::keystore_file],
  }

  apt::source { 'devopsnapratica':
    location      => 'http://192.168.33.16/',
    release       => 'devopspkgs',
    repos         => 'main',
    key           => '8044FB04',
    key_source    => 'http://192.168.33.16/devopspkgs.gpg',
    include_src   => false,
  }

  package { "devopsnapratica":
    ensure => "latest",
    require       => File["/var/lib/tomcat7/lib/mysql-connector-java-3.1.14-bin.jar"], 
    notify  => Service["tomcat7"],
  }
}
