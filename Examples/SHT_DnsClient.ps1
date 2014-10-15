configuration example {
    Import-DscResource -Module SYSTEMHOSTING

    Node 'localhost' {
 
        
        # The Windows default values are:
        #   RegisterThisConnectionAddress = $true
        #   UseSuffixWhenRegistering = $false
        # All properties are mandatory

        cDnsClient DnsClient {
            InterfaceAlias = 'Ethernet'
            RegisterThisConnectionAddress = $true
            UseSuffixWhenRegistering = $true
        }
    }
}