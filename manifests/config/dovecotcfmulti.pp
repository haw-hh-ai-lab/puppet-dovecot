define dovecot::config::dovecotcfmulti(
  $config_file='dovecot.conf',
  $changes=undef,
  $onlyif=undef,
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

  augeas { "dovecot /etc/dovecot/${config_file} ${name}":
    changes => $changes,
    onlyif  => $onlyif,
  }

}

