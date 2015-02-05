configuration example {
    Import-DscResource -Module SYSTEMHOSTING

    Node 'localhost' {
 
        # Renames a network adapter, identified by its MAC address.
        # PhysicalNetAdapterOnly is used if logical/virtual adapters on the server has taken the same MAC as the underlying NIC.
        # For example, when using NIC Teaming (LBFO), the team will by default have the same MAC as the first NIC in the team.

        cNetAdapterName NameNIC1 {
            MACAddress             = '00-11-22-33-44-55'
            InterfaceAlias         = 'LAN-NIC-1'
            PhysicalNetAdapterOnly = $true
        }
        cNetAdapterName NameNIC2 {
            MACAddress             = 'AA-BB-CC-DD-EE-FF'
            InterfaceAlias         = 'LAN-NIC-2'
        }
    }
}