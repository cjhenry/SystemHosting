configuration example {
    Import-DscResource -Module SYSTEMHOSTING

    Node 'localhost' {
 
        # Enables or disables an interface based on its InterfaceAlias property. Not much else to it.

        cNetAdapter DisableNIC {
            InterfaceAlias = 'Ethernet'
            Enabled        = $false
        }
        cNetAdapter EnableNIC {
            InterfaceAlias = 'Ethernet 2'
            Enabled        = $true
        }
    }
}