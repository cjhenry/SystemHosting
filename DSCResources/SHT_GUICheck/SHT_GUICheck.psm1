<#
 # SHT_GUICheck - A DSC resource for checking if the WindowsFeature for the graphical user interface
 # on a Windows Server is removed. If not, it can be set to ensure the feature is removed, or it will
 # simply write an eventlog entry.
 #
 # Authored by: Martin T. Nielsen - mni@systemhosting.dk
 #>

function Get-TargetResource
{
	param
	(
		[Parameter(Mandatory)]
		[string]$Enforce,

        [Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
        [string]$EventSource,

        [Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
        [string]$EventLog
	)
	
    Write-Verbose 'Get-TargetResource'
    foreach ($k in $PSBoundParameters.GetEnumerator()) {
        Write-Verbose ('{0} - {1}' -f $k.Key, $k.Value)
    }
    
    return @{
        Enforce = $Enforce
        EventLog = $EventLog
        EventSource = $EventSource
    }
}


function Set-TargetResource
{
	param
	(
		[Parameter(Mandatory)]
		[bool]$Enforce, 

        [Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
        [string]$EventSource,

        [Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
        [string]$EventLog
	)

    Write-Verbose 'Set-TargetResource'
    foreach ($k in $PSBoundParameters.GetEnumerator()) {
        Write-Verbose ('{0} - {1}' -f $k.Key, $k.Value)
    }

    $features = Get-WindowsFeature Server-Gui-Shell,Server-Gui-Mgmt-Infra
    
    foreach($feature in $features) { 
        if($feature.Installed) {
            New-EventLog -LogName $EventLog -Source $EventSource -ErrorAction SilentlyContinue
            $message = ('Detected that WindowsFeature "{0}" is installed' -f $feature.DisplayName)
            Write-Verbose $message
            Write-EventLog -LogName $EventLog -Source $EventSource -EntryType Warning -EventId 1 -Message $message
            
            if($Enforce) {
                $message = ('Enforce flag is set. Attempting to remove WindowsFeature "{0}"' -f $feature.DisplayName)
                Write-Verbose "EventLog: $message"
                Write-EventLog -LogName $EventLog -Source $EventSource -EntryType Warning -EventId 2 -Message $message

                Write-Verbose 'Removing WindowsFeature'
                $feature | Remove-WindowsFeature
            }
        }
    }
}


function Test-TargetResource
{
    param
	(
		[Parameter(Mandatory)]
		[bool]$Enforce, 

        [Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
        [string]$EventSource,

        [Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
        [string]$EventLog
	)

    Write-Verbose 'Test-TargetResource'
    foreach ($k in $PSBoundParameters.GetEnumerator()) {
        Write-Verbose ('{0} - {1}' -f $k.Key, $k.Value)
    }

    $features = Get-WindowsFeature Server-Gui-Shell,Server-Gui-Mgmt-Infra

    foreach($feature in $features) {
        if($feature.Installed) { 
            Write-Verbose ('WindowsFeature {0} is installed' -f $feature.Name)
            return $false
        }
    }
    
    return $true
}


Export-ModuleMember -Function Get-TargetResource, Set-TargetResource, Test-TargetResource