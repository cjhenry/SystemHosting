configuration example {
    Import-DscResource -Module SYSTEMHOSTING

    Node 'localhost' {
 
        # Valid values for the NetBios setting are:
        #   Enabled, Disabled, Default (Enabled)

        cNetAdapterNetBios NetBios { 
            InterfaceAlias = 'Ethernet'
            NetBios = 'Default'
        }
    }
}