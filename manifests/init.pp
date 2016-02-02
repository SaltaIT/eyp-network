# == Class: network
#
class network inherits network::params {

  exec { 'network restart' :
    command     => $network::params::service_restart_exec,
    refreshonly => true,
    path        => '/bin:/sbin:/usr/bin:/usr/sbin',
  }


}
