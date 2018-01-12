class loja_virtual::ci {
  include loja_virtual
  
  apt::ppa { 'ppa:openjdk-r/ppa': }

  package { ['git', 'maven2', 'openjdk-6-jdk', 'openjdk-8-jdk']:
    ensure => "installed",
    require => Class['apt'],
  }

  class { 'jenkins':
    install_java => false,
    config_hash => {
      'JAVA_ARGS' => { 'value' => '-Xmx256m' }
    },
  }

  $plugins = [
    'ssh-credentials',
    'credentials',
    'scm-api',
    'git-client',
    'git',
    'javadoc',
    'mailer',
    'maven-plugin',
    'greenballs',
    'ws-cleanup',
    'workflow-scm-step',
    'apache-httpcomponents-client-4-api',
    'jsch',
    'junit',
    'workflow-durable-task-step',
    'matrix-project',
    'resource-disposer',
    'structs',
    'display-url-api',
    'workflow-api',
    'workflow-step-api',
    'script-security',
    'workflow-support',
    'durable-task'
  ]

  jenkins::plugin { $plugins: }
}

