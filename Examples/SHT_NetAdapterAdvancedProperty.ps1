configuration example {
    Import-DscResource -Module SYSTEMHOSTING

    Node 'localhost' {
    
        # The properties available for use in *-NetAdapterAdvancedProperty depends entirely on the network adapter driver. Some drivers offer different features.
        # To get a full list of supported properties on your network adapter, run the following command:
        #   Get-NetAdapter -InterfaceAlias 'Ethernet' | Get-NetAdapterAdvancedProperty | Format-Table DisplayName, RegistryKeyword, RegistryValue, ValidRegistryValues
        
        cNetAdapterAdvancedProperty JumboPacket {
            InterfaceAlias = 'Ethernet'
            RegistryKeyword = '*JumboPacket'
            RegistryValue = '4088'
        }
        cNetAdapterAdvancedProperty RSS {
            InterfaceAlias = 'Ethernet'
            RegistryKeyword = '*RSS'
            RegistryValue = '1'
        }

        cNetAdapterAdvancedProperty NumRssQueues {
            InterfaceAlias = 'Ethernet'
            RegistryKeyword = '*NumRssQueues'
            RegistryValue = '8'
        }
    }
}