#
# activate ldap based authentication in a dovecot server
#
# Parameter:
#  ldap_hosts:             space separated list of hosts. host:port is allowed
#  ldap_base:              search base for ldap lookups
#  ldap_dn:                DN to bind to for authentication, when doing password lookups.
#                          Don't set if using auth_bind
#  ldap_dnpass:            Password to authenticate to DN for password lookups
#  ldap_auth_bind_userdn:  template for dn search for auth_bind
#  ldap_auth_bind:         (no/yes) activate auth_bind?
#  ldap_scope:             search scope for dn lookups
#  ldap_debug_level:       debug level
#  ldap_user_filter:       filter for user objects
#  ldap_pass_filter:       filter for password objects
#  ldap_pass_attrs:
#  ldap_iterate_attrs:
#  ldap_iterate_filter:
#
class dovecot::ldap (
  $ldap_hosts            = 'ldap.example.org:389',
  $ldap_dn               = 'cn=vmail,cn=users,dc=example,dc=org',
  $ldap_dnpass           = 'NotPassword#1234!',
  $ldap_auth_bind_userdn = 'cn=%n,cn=users,dc=example,dc=org',
  $ldap_base             = 'cn=users,dc=example,dc=org',
  $ldap_auth_bind        = 'no',
  $ldap_scope            = 'subtree',
  $ldap_debug_level      = '-1',
  $ldap_user_filter      = '(&(objectClass=user)(cn=%n))',
  $ldap_pass_filter      = '(&(objectClass=user)(cn=%n))',
  $ldap_pass_attrs       = 'cn=user', #cn is ldap attribute name, user is dovecot field
  $ldap_iterate_attrs    = 'cn=user',
  $ldap_iterate_filter   = '(objectClass=user)'
  ) {

  # TODO the next two files use same template, probably should be creating symlink....
  file { '/etc/dovecot/dovecot-ldap.conf.ext':
    ensure  => present,
    content => template('dovecot/dovecot-ldap.conf.ext'),
    mode    => '0600',
    owner   => root,
    group   => dovecot,
    before  => Exec['dovecot'],
  }

  file { '/etc/dovecot/dovecot-ldap-userdb.conf.ext':
    ensure  => present,
    content => template('dovecot/dovecot-ldap.conf.ext'),
    mode    => '0600',
    owner   => root,
    group   => dovecot,
    before  => Exec['dovecot'],
  }

  file { '/etc/dovecot/conf.d/auth-ldap.conf.ext':
    ensure  => present,
    content => template('dovecot/auth-ldap.conf.ext'),
    mode    => '0600',
    owner   => root,
    group   => dovecot,
    before  => Exec['dovecot'],
  }

  dovecot::config::dovecotcfmulti { 'ldapauth':
    config_file => 'conf.d/10-auth.conf',
    changes     => [
                    "set include 'auth-ldap.conf.ext'",
                    "rm  include[ . = 'auth-system.conf.ext']",
                    ],
    require     => File['/etc/dovecot/dovecot-ldap.conf.ext']
  }
}
