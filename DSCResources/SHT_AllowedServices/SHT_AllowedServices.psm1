<#
 # SHT_AllowedServices - A DSC resource for configuring a service whitelist.
 # Reports a warning in the eventlog, and can optionally enforce the list by shutting down
 # unregistered services.
 #
 # Authored by: Martin T. Nielsen - mni@systemhosting.dk
 #>

function Get-TargetResource
{
	param
	(
		[Parameter(Mandatory)]
		[string]$EnforceList,

        [Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
        [string]$EventSource,

        [Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
        [string]$EventLog,

        [Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
        [string[]]$Services


	)
	
    Write-Verbose 'Get-TargetResource'
    foreach ($k in $PSBoundParameters.GetEnumerator()) {
        Write-Verbose ('{0} - {1}' -f $k.Key, $k.Value)
    }
    
    return @{
        EnforceList = $EnforceList
        EventLog = $EventLog
        EventSource = $EventSource
        Services = $Services
    }
}


function Set-TargetResource
{
	param
	(
		[Parameter(Mandatory)]
		[bool]$EnforceList, 

        [Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
        [string]$EventSource,

        [Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
        [string]$EventLog,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
        [string[]]$Services
	)

    Write-Verbose 'Set-TargetResource'
    foreach ($k in $PSBoundParameters.GetEnumerator()) {
        Write-Verbose ('{0} - {1}' -f $k.Key, $k.Value)
    }

    $s = Get-ListOfNotAllowedServicesRunning -Services $Services

    $message = "The following services have been registered as running, but are not on the allowed list:`n"

    $message += foreach($service in $s) {
        Write-Output "`n$service"
        if($EnforceList) { Stop-Service $service -ErrorAction SilentlyContinue -Force }
    }

    Write-Verbose 'Written warning to eventlog'

    New-EventLog -LogName $EventLog -Source $EventSource -ErrorAction SilentlyContinue
    Write-EventLog -LogName $EventLog -Source $EventSource -EntryType Warning -EventId 1 -Message $message
}


function Test-TargetResource
{
    param
	(
		[Parameter(Mandatory)]
		[bool]$EnforceList, 

        [Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
        [string]$EventSource,

        [Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
        [string]$EventLog,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
        [string[]]$Services
	)

    Write-Verbose 'Test-TargetResource'
    foreach ($k in $PSBoundParameters.GetEnumerator()) {
        Write-Verbose ('{0} - {1}' -f $k.Key, $k.Value)
    }

    $s = Get-ListOfNotAllowedServicesRunning -Services $Services

    if($s.Count -gt 0) {
        Write-Verbose ('Found {0} services running that are not on the allowed list' -f $s.Count)
        Write-Verbose ('Service list: {0}' -f ($s -join ', '))
        return $false
    }
    
    return $true
}


function Get-ListOfNotAllowedServicesRunning {
    [CmdletBinding()]
    param(
        [string[]]$Services
    )

    Get-Service | Where-Object -FilterScript { $_.Status -eq 'Running' -and $_.Name -notin $Services } | Select-Object -ExpandProperty Name
}


Export-ModuleMember -function Get-TargetResource, Set-TargetResource, Test-TargetResource