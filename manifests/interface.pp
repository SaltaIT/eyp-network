define network::interface (
                            $dev=$name,
                            $ip=undef,
                            $netmask=undef,
                            $gateway=undef,
                            $dns=undef,
                            $onboot=true,
                            $dhcp=false,
                            $network_managed=true,
                          ) {
  #
  include ::network

  if($dhcp)
  {
    if($dns!=undef or $ip!=undef or $netmask!=undef or $gateway!=undef)
    {
      fail('Inconsistent configuration')
    }
  }
  else
  {
    if($ip==undef or $netmask==undef)
    {
      fail("Inconsistent configuration: ip: ${ip} netmask: ${netmask}")
    }
  }

  if($network_managed)
  {
    $notify_exec=Exec['network restart']
  }
  else
  {
    $notify_exec=undef
  }

  case $::osfamily
  {
    'RedHat':
    {
      file { "/etc/sysconfig/network-scripts/ifcfg-${dev}":
        ensure  => 'present',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template("${module_name}/redhat/interface.erb"),
        notify  => $notify_exec,
      }
    }
    'Debian':
    {

    }
    default: { fail('Operating system not supported')  }
  }
}
