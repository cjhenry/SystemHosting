<### 
 # SHT_NetAdapterName - A DSC resource for naming network adapters based on their MAC.
 # Authored by: Dennis Rye - dry@systemhosting.dk
 #>

function Get-TargetResource
{
    [CmdletBinding()]
	param
	(		
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
        [ValidateScript({Validate-MacAddress -MACAddress $_})]
        [string]$MACAddress,

        [Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
        [string]$InterfaceAlias,

        [bool]$PhysicalNetAdapterOnly
	)

    Write-Verbose 'Get-TargetResource'
    
    $netAdapter = Get-SingleNetAdapterByMac -MACAddress $MACAddress -Physical:$PhysicalNetAdapterOnly
	
    return @{
        MACAddress = $netAdapter.MacAddress
        InterfaceAlias = $netAdapter.InterfaceAlias
        PhysicalNetAdapterOnly = $PhysicalNetAdapterOnly
    }
}


function Set-TargetResource
{
    [CmdletBinding()]
	param
	(		
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
        [ValidateScript({Validate-MacAddress -MACAddress $_})]
        [string]$MACAddress,

        [Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
        [string]$InterfaceAlias,

        [bool]$PhysicalNetAdapterOnly
	)
    
    Write-Verbose 'Set-TargetResource'
    
    if (Get-NetAdapter -Name $InterfaceAlias -ErrorAction SilentlyContinue) {
        throw "A NetAdapter with InterfaceAlias $InterfaceAlias already exists"
    }

    Get-SingleNetAdapterByMac -MACAddress $MACAddress -Physical:$PhysicalNetAdapterOnly | Rename-NetAdapter -NewName $InterfaceAlias
}


function Test-TargetResource
{
    [CmdletBinding()]
	param
	(		
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
        [ValidateScript({Validate-MacAddress -MACAddress $_})]
        [string]$MACAddress,

        [Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
        [string]$InterfaceAlias,

        [bool]$PhysicalNetAdapterOnly
	)

    Write-Verbose 'Test-TargetResource'
    
    $adapterRenamed = $false

    $netAdapter = Get-SingleNetAdapterByMac -MACAddress $MACAddress -Physical:$PhysicalNetAdapterOnly
    
    if ($netAdapter.InterfaceAlias -eq $InterfaceAlias) {
        $adapterRenamed = $true
    }

    Write-Verbose "Testing network adapter"
    Write-Verbose "MAC: $MACAddress"
    Write-Verbose "InterfaceAlias: $($netAdapter.InterfaceAlias)"
    Write-Verbose "Expected InterfaceAlias: $InterfaceAlias"
    Write-Verbose "Returning: $adapterRenamed"

    return $adapterRenamed
}

function Validate-MacAddress {
    [Cmdletbinding()]
    param (
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true)]
		[ValidateNotNullOrEmpty()]
        [string]$MACAddress
    )

    if ($MACAddress.Length -eq 17) {
        $mac = $MACAddress.Replace('-','')
        if ($mac.Length -eq 12) {
            $mac -match '[a-fA-F0-9]{12}'
        }
        else {
            Write-Verbose 'MAC address must be in the format 00-11-22-33-44-55'
            return $false
        }
    }
    else {
        Write-Verbose 'MAC Address must be exactly 17 characters long, in the format 00-11-22-33-44-55'
        return $false
    }
}

function Get-SingleNetAdapterByMac {
    [Cmdletbinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$MACAddress,

        [switch]$Physical
    )

    $adapter = @(Get-NetAdapter -Physical:$Physical | where MacAddress -eq $MACAddress)
    if ($adapter.Count -eq 0) {
        throw "No NetAdapters found with MAC address $MACAddress"
    }
    elseif ($adapter.Count -eq 1) {
        return $adapter[0]
    }
    else {
        throw "Multiple NetAdapters found with MAC address $MACAddress"
    }
}

#  FUNCTIONS TO BE EXPORTED 
Export-ModuleMember -function Get-TargetResource, Set-TargetResource, Test-TargetResource