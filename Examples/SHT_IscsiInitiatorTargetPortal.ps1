configuration example {
    Import-DscResource -Module SYSTEMHOSTING

    Node 'localhost' {
    
        # This will add the iSCSI Target Portal to the iSCSI initiator, and the iSCSI initiator will determine which adapter to connect with
        cIscsiInitiatorTargetPortal TargetPortalOnly {
            TargetPortalAddress = '10.0.0.50'

        }

        # Instead of letting the iSCSI initiator determine which adapter to connect from, you can specify the IP address of the adapter to use
        cIscsiInitiatorTargetPortal TargetPortalWithInitiator {
            TargetPortalAddress    = '10.0.0.50'
            InitiatorPortalAddress = '10.0.0.10'
        }
    
        # You can also use the name of the network adapter instead
        cIscsiInitiatorTargetPortal TargetPortalWithInterfaceAlias {
            TargetPortalAddress = '10.0.0.50'
            InterfaceAlias      = 'Ethernet'
        }


        cIscsiInitiatorTargetPortal TargetPortalWithInitiatorAndTargets {
            TargetPortalAddress = '10.0.0.50'
            InterfaceAlias      = 'Ethernet'
            Targets             = @( # Put the targets in an array
                SHT_IscsiInitiatorTarget {
                    NodeAddress    = 'iqn.2002-03.com.my-san:test-target1'
                    InterfaceAlias = 'Ethernet'
                    MultiPath      = $true # Allows multiple connections to the same target
                    Persistent     = $true # Will reconnect target after a reboot
                }
                SHT_IscsiInitiatorTarget {
                    NodeAddress    = 'iqn.2002-03.com.my-san:test-target2'
                    InterfaceAlias = 'Ethernet'
                    MultiPath      = $true # Allows multiple connections to the same target
                    Persistent     = $true # Will reconnect target after a reboot
                }
            )
        }
    }
}