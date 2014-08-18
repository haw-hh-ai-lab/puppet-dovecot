define dovecot::config::dovecotcfsingle(
  $ensure = present,
  $config_file='dovecot.conf',
  $value=undef,
) {

  # changes in lenses are a sub set of changes provided by OS release
  if !(($::operatingsystem == 'Ubuntu') and ($::operatingsystemrelease >= '14.04')) {
    require dovecot::config::augeas
  }


  Augeas {
    context => "/files/etc/dovecot/${config_file}",
    notify  => Service['dovecot'],
    require => Exec['dovecot'],
  }

  case $ensure {
    present: {
      if !$value {
        fail("dovecot /etc/dovecot/${config_file} ${name} value not set")
      }
      augeas { "dovecot /etc/dovecot/${config_file} ${name}":
        changes => "set ${name} '${value}'",
      }
    }

    absent: {
      augeas { "dovecot /etc/dovecot/${config_file} ${name}":
        changes => "rm ${name}",
      }
    }
    default : {
      notice('unknown ensure value use absent or present')
    }
  }
}

