<### 
 # SHT_IscsiInitiatorTargetPortal - A DSC resource for modifying target portals and targets of the Microsoft iSCSI Initiator.
 # Authored by: Dennis Rye - dry@systemhosting.dk
 #>

Set-StrictMode -Version 2

function Get-TargetResource
{
    [CmdletBinding()]
	param
	(
		[Parameter(Mandatory)]
        [ValidateScript({Validate-IpAddress -IpAddress $_})]
        [string]$TargetPortalAddress,

		[ValidateNotNullOrEmpty()]
        [int]$TargetPortalPortNumber,

        [ValidateScript({Validate-IpAddress -IpAddress $_})]
        [Parameter(ParameterSetName='InitiatorPortalAddress', Mandatory = $true)]
        [string]$InitiatorPortalAddress,

        [ValidateNotNullOrEmpty()]
        [Parameter(ParameterSetName='InterfaceAlias', Mandatory = $true)]
        [string]$InterfaceAlias,

        [Microsoft.Management.Infrastructure.CimInstance[]]$Targets
	)

    if ($TargetPortalPortNumber -eq 0) {
        $PSBoundParameters.Add('TargetPortalPortNumber', 3260) | Out-Null
        $TargetPortalPortNumber = 3260
    }

    if ($InitiatorPortalAddress -eq $null) {
        $PSBoundParameters.Remove('InitiatorPortalAddress') | Out-Null
    }
    
    if ($InterfaceAlias -ne $null) {
        $InitiatorPortalAddress = Get-InitiatorPortalAddressFromInterfaceAlias -InterfaceAlias $InterfaceAlias
        $PSBoundParameters.Add('InitiatorPortalAddress', $InitiatorPortalAddress) | Out-Null
        
    }

    $PSBoundParameters.Remove('InterfaceAlias') | Out-Null
    $PSBoundParameters.Remove('Targets') | Out-Null
    $PSBoundParameters.Remove('Debug') | Out-Null

    $targetPortal = Get-IscsiTargetPortal @PSBoundParameters
    $availableTargets = $targetPortal | Get-IscsiTarget
    $confirmedTargets = [CimInstance[]]@()

    foreach ($t in $Targets) {
        $addTarget = $false

        foreach ($initiator in $t.InitiatorPortalAddress) {
            $session = $availableTargets | where {$_.NodeAddress -eq $t.NodeAddress} | Get-IscsiSession | where {$_.InitiatorPortalAddress -eq $initiator}

            if (-not $session) {
                throw ('No sessions found for {0} with initiator {1}' -f $t.NodeAddress, $initiator)
            }

            $addTarget = $true
        }

        if ($addTarget) {
            $confirmedTargets += $t
        }
    }

    return @{
        TargetPortalAddress    = $targetPortal.TargetPortalAddress
        TargetPortalPortNumber = $targetPortal.TargetPortalPortNumber
        InitiatorPortalAddress = $targetPortal.InitiatorPortalAddress
        Targets                = $confirmedTargets
    }
}


function Set-TargetResource
{
    [CmdletBinding()]
	param
	(
		[Parameter(Mandatory)]
        [ValidateScript({Validate-IpAddress -IpAddress $_})]
        [string]$TargetPortalAddress,

		[ValidateNotNullOrEmpty()]
        [int]$TargetPortalPortNumber,

        [ValidateScript({Validate-IpAddress -IpAddress $_})]
        [Parameter(ParameterSetName='InitiatorPortalAddress', Mandatory = $true)]
        [string]$InitiatorPortalAddress,

        [ValidateNotNullOrEmpty()]
        [Parameter(ParameterSetName='InterfaceAlias', Mandatory = $true)]
        [string]$InterfaceAlias,

        [Microsoft.Management.Infrastructure.CimInstance[]]$Targets
	)

    if ($TargetPortalPortNumber -eq 0) {
        $PSBoundParameters.Add('TargetPortalPortNumber', 3260) | Out-Null
        $TargetPortalPortNumber = 3260
    }

    if ($InitiatorPortalAddress -eq $null) {
        $PSBoundParameters.Remove('InitiatorPortalAddress') | Out-Null
    }

    if ($InterfaceAlias -ne $null) {
        $InitiatorPortalAddress = Get-InitiatorPortalAddressFromInterfaceAlias -InterfaceAlias $InterfaceAlias
        $PSBoundParameters.Add('InitiatorPortalAddress', $InitiatorPortalAddress) | Out-Null
        
    }

    $PSBoundParameters.Remove('InterfaceAlias') | Out-Null
    $PSBoundParameters.Remove('Targets') | Out-Null
    $PSBoundParameters.Remove('Debug') | Out-Null

    Write-Verbose ('Adding iSCSI initiator target portal {0}:{1}' -f $TargetPortalAddress, $TargetPortalPortNumber)
    New-IscsiTargetPortal @PSBoundParameters -ErrorAction 'Stop'
    Write-Verbose 'Refreshing target portal'
    Update-IscsiTargetPortal -TargetPortalAddress $TargetPortalAddress

    if ($Targets -ne $null) {
        foreach ($t in $Targets) {
            $sessions = Get-IscsiTarget -NodeAddress $t.NodeAddress | Get-IscsiSession -ErrorAction SilentlyContinue

            if ($t.InterfaceAlias -ne $null) {
                $t.InitiatorPortalAddress = foreach ($ia in $t.InterfaceAlias) {
                    Write-Output (Get-InitiatorPortalAddressFromInterfaceAlias -InterfaceAlias $ia)
                }
            }

            foreach ($initiator in $t.InitiatorPortalAddress) {
                $connectInitiator = $false

                if ($sessions) {
                    $session = $sessions | where {$_.InitiatorPortalAddress -eq $initiator}
                    if ($session) {
                        Write-Verbose ('Target {0} is already connected on initiator {1}' -f $t.NodeAddress, $initiator)
                        if ($t.Persistent) {
                            Write-Verbose ('Setting persistency to {0} and MultiPath to {1}' -f $t.Persistent, $t.MultiPath)

                            #Some targets will incorrectly report persistency as false, even though it is persistent. As a workaround, we unregister the session first
                            $session | Unregister-IscsiSession -ErrorAction SilentlyContinue

                            $session | Register-IscsiSession -IsMultipathEnabled $t.MultiPath
                        }
                        else {
                            Write-Verbose ('Removing persistency')
                            $session | Unregister-IscsiSession
                        }
                    }
                    else {
                        $connectInitiator = $true
                    }
                }
                else {
                    $connectInitiator = $true
                }

                if ($connectInitiator) {
                    Write-Verbose ('Connecting target {0} with initiator {1}' -f $t.NodeAddress, $initiator)
                    Connect-IscsiTarget -NodeAddress $t.NodeAddress -InitiatorPortalAddress $initiator -IsPersistent $t.Persistent -IsMultipathEnabled $t.MultiPath
                }
            }
        }
    }
    else {
        Write-Verbose ('No targets to connect')
    }
}


function Test-TargetResource
{
    [CmdletBinding()]
	param
	(
		[Parameter(Mandatory)]
        [ValidateScript({Validate-IpAddress -IpAddress $_})]
        [string]$TargetPortalAddress,

		[ValidateNotNullOrEmpty()]
        [int]$TargetPortalPortNumber,

        [ValidateScript({Validate-IpAddress -IpAddress $_})]
        [Parameter(ParameterSetName='InitiatorPortalAddress', Mandatory = $true)]
        [string]$InitiatorPortalAddress,

        [ValidateNotNullOrEmpty()]
        [Parameter(ParameterSetName='InterfaceAlias', Mandatory = $true)]
        [string]$InterfaceAlias,

        [Microsoft.Management.Infrastructure.CimInstance[]]$Targets
	)
    
    if ($TargetPortalPortNumber -eq 0) {
        $PSBoundParameters.Add('TargetPortalPortNumber', 3260) | Out-Null
        $TargetPortalPortNumber = 3260
    }

    if ($InitiatorPortalAddress -eq $null) {
        $PSBoundParameters.Remove('InitiatorPortalAddress') | Out-Null
    }
    
    if ($InterfaceAlias -ne $null) {
        $InitiatorPortalAddress = Get-InitiatorPortalAddressFromInterfaceAlias -InterfaceAlias $InterfaceAlias
        $PSBoundParameters.Add('InitiatorPortalAddress', $InitiatorPortalAddress) | Out-Null
        
    }

    $PSBoundParameters.Remove('InterfaceAlias') | Out-Null
    $PSBoundParameters.Remove('Targets') | Out-Null
    $PSBoundParameters.Remove('Debug') | Out-Null

    foreach ($k in $PSBoundParameters.GetEnumerator()) {
        Write-Verbose ('{0}: {1}' -f $k.Key, $k.Value)
    }

    if (-not (Test-IscsiTargetPortal @PSBoundParameters)) {
        return $false
    }

    if ($Targets -ne $null) {
        foreach ($t in $Targets) {
            Write-Verbose ('Checking if target {0} exists on target portal' -f $t.NodeAddress)
            if (-not (Test-IscsiTargetAvailable -NodeAddress $t.NodeAddress)) {
                Write-Verbose 'Refreshing target portal'
                Update-IscsiTargetPortal -TargetPortalAddress $TargetPortalAddress
                    
                if (-not (Test-IscsiTargetAvailable -NodeAddress $t.NodeAddress)) {
                    throw ('No available target found that matches {0} on target portal {1}:{2}' -f $t.NodeAddress, $TargetPortalAddress, $TargetPortalPortNumber)
                }
            }

            if ($t.InterfaceAlias -ne $null) {
                $t.InitiatorPortalAddress = foreach ($ia in $t.InterfaceAlias) {
                    Write-Output (Get-InitiatorPortalAddressFromInterfaceAlias -InterfaceAlias $ia)
                }
            }

            foreach ($initiator in $t.InitiatorPortalAddress) {
                if (-not (Validate-IpAddress -IpAddress $initiator)) {
                    throw ('The initiator IP address {0} is invalid' -f $initiator)
                }

                Write-Verbose ('Checking sessions matching initiator IP {0}' -f $initiator)

                if (-not (Test-IscsiTargetSession -NodeAddress $t.NodeAddress -InitiatorPortalAddress $initiator)) {
                    Write-Verbose ('Target {0} is not connected by initiator {1}' -f $t.NodeAddress, $initiator)
                    return $false
                }
                else {
                    Write-Verbose ('Target {0} is connected by initiator {1}' -f $t.NodeAddress, $initiator)

                    if (-not (Test-IscsiTargetSession -NodeAddress $t.NodeAddress -InitiatorPortalAddress $initiator -Persistent $t.Persistent)) {
                        Write-Verbose ('Target {0} persistency is {1}, but expected {2}' -f $t.NodeAddress, (-not $t.Persistent), $t.Persistent)
                        return $false
                    }
                }
            }
        }
    }
    else {
        Write-Verbose 'No targets specified for target portal'
    }

    return $true
}

function Validate-IpAddress {
    [Cmdletbinding()]
    param (
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true)]
		[ValidateNotNullOrEmpty()]
        [string]$IpAddress
    )

    [ipaddress]::TryParse($IpAddress, [ref]$null)
}

function Test-IscsiTargetPortal {
    [Cmdletbinding()]
    param (
    	[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
        [ValidateScript({Validate-IpAddress -IpAddress $_})]
        [string]$TargetPortalAddress,

        [Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
        [int]$TargetPortalPortNumber,

        [ValidateScript({Validate-IpAddress -IpAddress $_})]
        [string]$InitiatorPortalAddress
    )

    if ($InitiatorPortalAddress -eq $null) {
        $PSBoundParameters.Remove('InitiatorPortalAddress') | Out-Null
    }
    $PSBoundParameters.Remove('Debug') | Out-Null

    Write-Verbose ('Testing iSCSI target portal {0}:{1}' -f $TargetPortalAddress, $TargetPortalPortNumber)
    $targetPortal = Get-IscsiTargetPortal @PSBoundParameters -ErrorAction SilentlyContinue

    if (-not $targetPortal) {
        Write-Verbose 'Target portal not found'
        return $false
    }
    else {
        return $true
    }
}

function Test-IscsiTargetAvailable {
    [Cmdletbinding()]
    param (
    	[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
        [string]$NodeAddress
    )

    $target = Get-IscsiTarget -NodeAddress $NodeAddress -ErrorAction SilentlyContinue

    if (-not $target) {
        return $false
    }
    else {
        return $true
    }
}

function Test-IscsiTargetSession {
    [Cmdletbinding()]
    param (
    	[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
        [string]$NodeAddress,

        [Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
        [ValidateScript({Validate-IpAddress -IpAddress $_})]
        [string]$InitiatorPortalAddress,

        [bool]$Persistent
    )

    $sessions = Get-IscsiTarget -NodeAddress $NodeAddress | Get-IscsiSession -ErrorAction SilentlyContinue

    if (-not $sessions) {
        return $false
    }
    
    $session = $sessions | where {$_.InitiatorPortalAddress -eq $InitiatorPortalAddress}

    if (-not $session) {
        return $false
    }

    if ($Persistent) {
        if (-not $session.IsPersistent) {
            return $false
        }
    }

    return $true
}

function Get-InitiatorPortalAddressFromInterfaceAlias {
    [Cmdletbinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$InterfaceAlias
    )

    return (Get-NetIPAddress -InterfaceAlias $InterfaceAlias -AddressFamily 'IPv4')[0].IPAddress
}

Export-ModuleMember -function Get-TargetResource, Set-TargetResource, Test-TargetResource