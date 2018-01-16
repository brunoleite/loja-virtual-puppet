class loja_virtual::ci inherits loja_virtual {
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

  file { '/var/lib/jenkins/hudson.tasks.Maven.xml':
    mode    => '0644',
    owner   => 'jenkins',
    group   => 'jenkins',
    source  => 'puppet:///modules/loja_virtual/hudson.tasks.Maven.xml',
    require => Class['jenkins::package'],
    notify  => Service['jenkins'],
  }

  $job_structure = [
    '/var/lib/jenkins/jobs/',
    '/var/lib/jenkins/jobs/loja-virtual-devops'
  ]
  $git_repository = 'https://github.com/brunoleite/loja-virtual-devops.git'
  $git_poll_interval = '* * * * *'
  $maven_goal = 'install'
  $archive_artifacts = 'combined/target/*.war'
  $repo_dir = '/var/lib/apt/repo'
  $repo_name = 'devopspkgs'

  file { $job_structure[1]:
    ensure => 'directory',
    owner  => 'jenkins',
    group  => 'jenkins',
    require => [
        File['/var/lib/jenkins/jobs/'],
        Class['jenkins::package']
      ],
  }
  
  file { "${job_structure[1]}/config.xml":
    mode    => '0644',
    owner   => 'jenkins',
    group   => 'jenkins',
    content => template('loja_virtual/config.xml'),
    require => File[$job_structure],
    notify  => Service['jenkins'],
  }

  class { 'loja_virtual::repo':
    basedir => $repo_dir,
    param_name => $repo_name,
  }
}

