class tomcat::server($connectors = [], $data_sources = []) {
  package { "tomcat7":
    ensure => installed,
    require => Exec["apt-update"],
  }
  
  file { "/etc/default/tomcat7":
    owner => root,
    group => root,
    mode  => 0644,
    source => "puppet:///modules/tomcat/tomcat7",
    require => Package["tomcat7"],
    notify => Service["tomcat7"],
  }
 
  file { "/var/lib/tomcat7/conf/server.xml":
    owner   => root,
    group   => tomcat7,
    mode    => 0644,
    content => template("tomcat/server.xml"),
    require => Package["tomcat7"],
    notify  => Service["tomcat7"],
  }

  file { "/var/lib/tomcat7/conf/context.xml":
    owner   => root,
    group   => tomcat7,
    mode    => 0644,
    content => template("tomcat/context.xml"),
    require => Package["tomcat7"],
    notify  => Service["tomcat7"],
  }

  file { "/var/lib/tomcat7/lib":
    ensure => "directory",
    owner => tomcat7,
    group => tomcat7,
    mode => 0644,
  }
  
  file { "/var/lib/tomcat7/lib/mysql-connector-java-3.1.14-bin.jar":
    owner => tomcat7,
    group => tomcat7,
    mode => 0644,
    source => "puppet:///modules/tomcat/mysql-connector-java-3.1.14-bin.jar",
    require => [
      File["/var/lib/tomcat7/lib"], 
      Package["tomcat7"]
    ],
    notify => Service["tomcat7"],
  }
  
  service { "tomcat7":
    ensure => running,
    enable => true,
    hasstatus => true,
    hasrestart => true,
    require  => Package["tomcat7"],
  }
}

