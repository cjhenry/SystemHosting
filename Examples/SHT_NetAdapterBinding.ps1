configuration example {
    Import-DscResource -Module SYSTEMHOSTING

    Node 'localhost' {
 
        # The bindings available for use in *-NetAdapterBinding depends on your specific setup. Some applications may add additional bindings that are not availble on a default installation.
        # To get a full list of available bindings on your network adapter, run the following command:
        #   Get-NetAdapter -InterfaceAlias 'Ethernet' | Get-NetAdapterBinding | Format-Table DisplayName, ComponentID, Enabled

        cNetAdapterBinding IPv4 {
            InterfaceAlias = 'Ethernet'
            ComponentID = 'ms_tcpip'
            Enabled = $true
        }

        cNetAdapterBinding IPv6 {
            InterfaceAlias = 'Ethernet'
            ComponentID = 'ms_tcpip6'
            Enabled = $true
        }

        cNetAdapterBinding FilePrintSharing {
            InterfaceAlias = 'Ethernet'
            ComponentID = 'ms_server'
            Enabled = $true
        }
    }
}