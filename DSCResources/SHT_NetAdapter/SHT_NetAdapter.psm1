<### 
 # SHT_NetAdapter - A DSC resource for enabling/disabling network adapters.
 # Authored by: Dennis Rye - dry@systemhosting.dk
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
        [bool]$Enabled
	)

    Write-Verbose 'Get-TargetResource'
    foreach ($k in $PSBoundParameters.GetEnumerator()) {
        Write-Verbose ('{0} - {1}' -f $k.Key, $k.Value)
    }
	
    return @{
        InterfaceAlias = $InterfaceAlias
        Enabled = $Enabled
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
        [bool]$Enabled
	)
    
    Write-Verbose 'Set-TargetResource'
    foreach ($k in $PSBoundParameters.GetEnumerator()) {
        Write-Verbose ('{0} - {1}' -f $k.Key, $k.Value)
    }

    if ($Enabled) {
        Write-Verbose "Enabling $($InterfaceAlias)"
        Enable-NetAdapter -Name $InterfaceAlias
    }
    else {
        Write-Verbose "Disabling ($InterfaceAlias)"
        Disable-NetAdapter -Name $InterfaceAlias
    }
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
        [bool]$Enabled
	)

    Write-Verbose 'Test-TargetResource'
    foreach ($k in $PSBoundParameters.GetEnumerator()) {
        Write-Verbose ('{0} - {1}' -f $k.Key, $k.Value)
    }

    $adapterEnabled = $false
            
    if ((Get-NetAdapter -Name $InterfaceAlias).AdminStatus -eq 'Up') {
        Write-Verbose 'NetAdapter is enabled'
        $adapterEnabled = $true
    }
    else {
        Write-Verbose 'NetAdapter is disabled'
    }

    return $adapterEnabled -eq $Enabled
}


#  FUNCTIONS TO BE EXPORTED 
Export-ModuleMember -function Get-TargetResource, Set-TargetResource, Test-TargetResource