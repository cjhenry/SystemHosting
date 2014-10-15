# SYSTEMHOSTING
This DSC module is maintained by the developers at systemhosting.dk

* Martin T. Nielsen / mni@systemhosting.dk
* Dennis Rye / dry@systemhosting.dk

## Howto
The module is installed by placing the entirety of the SYSTEMHOSTING folder structure in your PowerShell modules folder, which by default is C:\Program Files\WindowsPowerShell\Modules

## Resources
The following DSC resources are available in this module

### SHT_AllowedServices
_Alias: cAllowedServices_

A DSC resource for configuring a service whitelist.
Reports a warning in the eventlog, and can optionally enforce the list by shutting down unregistered services.

### SHT_DnsClient
_Alias: cDnsClient_

A DSC resource for modifying the IPv4 Dns Client settings on a network adapter.

### SHT_GroupResource
_Alias: cGroup_

A modified version of the MSFT_GroupResource DSC resource containing the following bugfix:
https://connect.microsoft.com/PowerShell/feedbackdetail/view/951681/desired-state-configuration-group-resource

### SHT_IscsiInitiatorTargetPortal
_Alias: cIscsiInitiatorTargetPortal_

A DSC resource for modifying target portals and targets of the Microsoft iSCSI Initiator.

### SHT_MPIOSetting
_Alias: cMPIOSetting_

A DSC resource for configuring global MPIO settings. 

### SHT_NetAdapter
_Alias: cNetAdapter_

A DSC resource for enabling/disabling network adapters.

### SHT_NetAdapterAdvancedProperty
_Alias: cNetAdapterAdvancedProperty_

A DSC resource for modifying network adapter driver settings.

### SHT_NetAdapterBinding
_Alias: cNetAdapterBinding_

A DSC resource for modifying network adapter bindings.

### SHT_NetAdapterNetBios
_Alias: cNetAdapterNetBios_

A DSC resource for modifying the IPv4 NetBios settings.

