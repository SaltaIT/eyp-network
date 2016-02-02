define network::route (
                        $eth,
                        $gw,
                        $network=$name,
                        $ensure = 'present',
                        $order='01',
                        $network_managed=true,
                      ) {

  include ::network

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
      if ! defined(Concat["/etc/sysconfig/network-scripts/route-${eth}"])
      {
        concat { "/etc/sysconfig/network-scripts/route-${eth}":
          ensure  => $ensure,
          mode    => '0644',
          owner   => 'root',
          group   => 'root',
          notify  => $notify_exec,
        }

        concat::fragment{ "route ${eth} header":
          target  => "/etc/sysconfig/network-scripts/route-${eth}",
          order   => '00',
          content => "# puppet managed file\n",
        }
      }

      concat::fragment{ "route ${name} ${gw} ${network}":
        target  => "/etc/sysconfig/network-scripts/route-${eth}",
        order   => $order,
        content => template("${module_name}/redhat/route.erb"),
      }

    }
    'Debian':
    {
      #/etc/network/if-down.d/
      #/etc/network/if-up.d/
      fail('TODO!')
    }
    default: { fail('Operating system not supported')  }
  }

}
