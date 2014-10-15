<#
 # SHT_DnsClient - A DSC resource for modifying the IPv4 Dns Client settings on a network adapter.
 #
 # Authored by: Martin T. Nielsen - mni@systemhosting.dk
 #>

function Get-TargetResource
{
    [CmdletBinding()]
	param
	(		
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
        [string]$InterfaceAlias,

        [Parameter(Mandatory)]
        [bool]$RegisterThisConnectionAddress,

        [Parameter(Mandatory)]
        [bool]$UseSuffixWhenRegistering

	)
	
    Write-Verbose 'Get-TargetResource'
    foreach ($k in $PSBoundParameters.GetEnumerator()) {
        Write-Verbose ('{0} - {1}' -f $k.Key, $k.Value)
    }
    
    return @{
        InterfaceAlias = $InterfaceAlias
        RegisterThisConnectionAddress = $RegisterThisConnectionAddress
        UseSuffixWhenRegistering = $UseSuffixWhenRegistering
    }
}


function Set-TargetResource
{
    [CmdletBinding()]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
        [string]$InterfaceAlias,

        [Parameter(Mandatory)]
        [bool]$RegisterThisConnectionAddress,

        [Parameter(Mandatory)]
        [bool]$UseSuffixWhenRegistering
	)
    
    Write-Verbose 'Set-TargetResource'
    foreach ($k in $PSBoundParameters.GetEnumerator()) {
        Write-Verbose ('{0} - {1}' -f $k.Key, $k.Value)
    }

    Get-DnsClient -InterfaceAlias $InterfaceAlias | Set-DnsClient -UseSuffixWhenRegistering $UseSuffixWhenRegistering -RegisterThisConnectionsAddress $RegisterThisConnectionAddress
}


function Test-TargetResource
{
    [CmdletBinding()]
    param
	(		
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$InterfaceAlias,

        [Parameter(Mandatory)]
        [bool]$RegisterThisConnectionAddress,

        [Parameter(Mandatory)]
        [bool]$UseSuffixWhenRegistering
	)

    Write-Verbose 'Test-TargetResource'
    foreach ($k in $PSBoundParameters.GetEnumerator()) {
        Write-Verbose ('{0} - {1}' -f $k.Key, $k.Value)
    }

    $properties = Get-DnsClient -InterfaceAlias $InterfaceAlias

    if($properties.RegisterThisConnectionAddress -ne $RegisterThisConnectionAddress) {
        Write-Verbose ('Configuration mismatch in property RegisterThisConnectionAddress. Set value: {0}. Expected value: {1}.' -f $properties.RegisterThisConnectionAddress, $RegisterThisConnectionAddress)
        return $false
    }
    
    if($properties.UseSuffixWhenRegistering -ne $UseSuffixWhenRegistering) {
        Write-Verbose ('Configuration mismatch in property UseSuffixWhenRegistering. Set value: {0}. Expected value: {1}.' -f $properties.UseSuffixWhenRegistering, $UseSuffixWhenRegistering)
        return $false
    }
    
    return $true
}


Export-ModuleMember -function Get-TargetResource, Set-TargetResource, Test-TargetResource