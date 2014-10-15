<### 
 # SHT_AllowedServices - A DSC resource for configuring global MPIO settings. 
 # All changes require a reboot to take effect. This script does not handle rebooting servers.
 #
 # Authored by: Martin T. Nielsen - mni@systemhosting.dk
 #>
 
function Get-TargetResource
{
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[bool]$EnforceDefaults
	)
	
    Write-Verbose "Get-TargetResource"
    foreach ($k in $PSBoundParameters.GetEnumerator()) {
        Write-Verbose ('{0} - {1}' -f $k.Key, $k.Value)
    }
    
    $settings = Get-MPIOSettingProper

    return @{
        EnforceDefaults = $EnforceDefaults
        PathVerificationPeriod = $settings.PathVerificationPeriod
        PathVerificationState = $settings.PathVerificationState
        PDORemovePeriod = $settings.PDORemovePeriod
        RetryCount = $settings.RetryCount
        RetryInterval = $settings.RetryInterval
        DiskTimeout = $settings.DiskTimeoutValue
        UseCustomPathRecovery = $settings.UseCustomPathRecoveryTime
        CustomPathRecovery = $settings.CustomPathRecoveryTime
    }
}


function Set-TargetResource
{
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[bool]$EnforceDefaults,

        [ValidateRange(1,9999)]
        [int]$PathVerificationPeriod,

        [ValidateSet("Enabled","Disabled")]
        [string]$PathVerificationState,

        [ValidateRange(10,9999)]
        [int]$PDORemovePeriod,

        [ValidateRange(3,9999)]
        [int]$RetryCount,

        [ValidateRange(1,9999)]
        [int]$RetryInterval,

        [ValidateRange(10,100)]
        [int]$DiskTimeout,

        [ValidateSet("Enabled","Disabled")]
        [string]$UseCustomPathRecovery,

        [ValidateRange(10,9999)]
        [int]$CustomPathRecovery
	)

    Write-Verbose "Set-TargetResource"
    foreach ($k in $PSBoundParameters.GetEnumerator()) {
        Write-Verbose ('{0} - {1}' -f $k.Key, $k.Value)
    }

    if($EnforceDefaults) {
        if(-not $PSBoundParameters.ContainsKey('PathVerificationPeriod')) { $PSBoundParameters.Add('PathVerificationPeriod', 30);        $PathVerificationPeriod = 30 }
        if(-not $PSBoundParameters.ContainsKey('PathVerificationState'))  { $PSBoundParameters.Add('PathVerificationState', 'Disabled'); $PathVerificationState = 'Disabled' }
        if(-not $PSBoundParameters.ContainsKey('PDORemovePeriod'))        { $PSBoundParameters.Add('PDORemovePeriod',        20);        $PDORemovePeriod = 20 }
        if(-not $PSBoundParameters.ContainsKey('RetryCount'))             { $PSBoundParameters.Add('RetryCount',             3);         $RetryCount = 3 }
        if(-not $PSBoundParameters.ContainsKey('RetryInterval'))          { $PSBoundParameters.Add('RetryInterval',          1);         $RetryInterval = 1 }
        if(-not $PSBoundParameters.ContainsKey('DiskTimeout'))            { $PSBoundParameters.Add('DiskTimeout',            60);        $DiskTimeout = 60 }
        if(-not $PSBoundParameters.ContainsKey('UseCustomPathRecovery'))  { $PSBoundParameters.Add('UseCustomPathRecovery', 'Disabled'); $UseCustomPathRecovery = 'Disabled' }
        if(-not $PSBoundParameters.ContainsKey('CustomPathRecovery'))     { $PSBoundParameters.Add('CustomPathRecovery',     40);        $CustomPathRecovery = 40 }
    }

    $settings = Get-MPIOSettingProper
    
    Write-Verbose 'Looking up PathVerificationPeriod'
    if($PSBoundParameters.ContainsKey('PathVerificationPeriod')) {
        Write-Verbose 'Testing PathVerificationPeriod'
        if($PathVerificationPeriod -ne $settings.PathVerificationPeriod) { 
            Write-Verbose 'Setting PathVerificationPeriod'
            Set-MPIOSettingProper -NewPathVerificationPeriod $PathVerificationPeriod
        }
    }

    Write-Verbose 'Looking up PathVerificationState'
    if($PSBoundParameters.ContainsKey('PathVerificationState')) {
        Write-Verbose 'Testing PathVerificationState'
        if($PathVerificationState -ne $settings.PathVerificationState) { 
            Write-Verbose 'Setting PathVerificationState'
            Set-MPIOSettingProper -NewPathVerificationState $PathVerificationState
        }
    }
    
    Write-Verbose 'Looking up PDORemovePeriod'
    if($PSBoundParameters.ContainsKey('PDORemovePeriod')) {
        Write-Verbose 'Testing PDORemovePeriod'
        if($PDORemovePeriod -ne $settings.PDORemovePeriod) {  
            Write-Verbose 'Setting PDORemovePeriod'
            Set-MPIOSettingProper -NewPDORemovePeriod $PDORemovePeriod
        }
    }
    
    Write-Verbose 'Looking up RetryCount'
    if($PSBoundParameters.ContainsKey('RetryCount')) {
        Write-Verbose 'Testing RetryCount'
        if($RetryCount -ne $settings.RetryCount) {  
            Write-Verbose 'Setting RetryCount'
            Set-MPIOSettingProper -NewRetryCount $RetryCount
        }
    }
    
    Write-Verbose 'Looking up RetryInterval'
    if($PSBoundParameters.ContainsKey('RetryInterval')) {
        Write-Verbose 'Testing RetryInterval'
        if($RetryInterval -ne $settings.RetryInterval) {  
            Write-Verbose 'Setting '
            Set-MPIOSettingProper -NewRetryInterval $RetryInterval
        }
    }
    
    Write-Verbose 'Looking up DiskTimeout (DiskTimeoutValue)'
    if($PSBoundParameters.ContainsKey('DiskTimeout')) {
        Write-Verbose 'Testing DiskTimeout'

        # thanks microsoft for making parameter and setting values different
        if($DiskTimeout -ne $settings.DiskTimeoutValue) {  
            Write-Verbose 'Setting DiskTimeout'
            Set-MPIOSettingProper -NewDiskTimeout $DiskTimeout
        }
    }
    
    Write-Verbose 'Looking up UseCustomPathRecovery (CustomPathRecovery)'
    if($PSBoundParameters.ContainsKey('UseCustomPathRecovery')) {
        Write-Verbose 'Testing UseCustomPathRecovery'

        # thanks microsoft for making parameter and setting values different
        if($UseCustomPathRecovery -ne $settings.UseCustomPathRecoveryTime) {  
            Write-Verbose 'Setting UseCustomPathRecovery'
            Set-MPIOSettingProper -CustomPathRecovery $UseCustomPathRecovery
        }
    }
    
    Write-Verbose 'Looking up CustomPathRecovery (NewPathRecoveryInterval)'
    if($PSBoundParameters.ContainsKey('CustomPathRecovery')) {
        Write-Verbose 'Testing CustomPathRecovery'

        # thanks microsoft for making parameter and setting values different
        if($CustomPathRecovery -ne $settings.CustomPathRecoveryTime) {  
            Write-Verbose 'Setting CustomPathRecovery'
            Set-MPIOSettingProper -NewPathRecoveryInterval $CustomPathRecovery
        }
    }
}


function Test-TargetResource
{
    param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[bool]$EnforceDefaults,

        [ValidateRange(1,9999)]
        [int]$PathVerificationPeriod,

        [ValidateSet("Enabled","Disabled")]
        [string]$PathVerificationState,

        [ValidateRange(10,9999)]
        [int]$PDORemovePeriod,

        [ValidateRange(3,9999)]
        [int]$RetryCount,

        [ValidateRange(1,9999)]
        [int]$RetryInterval,

        [ValidateRange(10,100)]
        [int]$DiskTimeout,

        [ValidateSet("Enabled","Disabled")]
        [string]$UseCustomPathRecovery,

        [ValidateRange(10,9999)]
        [int]$CustomPathRecovery
	)

    Write-Verbose "Test-TargetResource"
    foreach ($k in $PSBoundParameters.GetEnumerator()) {
        Write-Verbose ('{0} - {1}' -f $k.Key, $k.Value)
    }

    if((Get-WindowsFeature Multipath-IO).InstallState -ne 'Installed') {
        throw "WindowsFeature Multipath-IO is not installed"
    }

    if($EnforceDefaults) {
        if(-not $PSBoundParameters.ContainsKey('PathVerificationPeriod')) { $PSBoundParameters.Add('PathVerificationPeriod', 30);        $PathVerificationPeriod = 30 }
        if(-not $PSBoundParameters.ContainsKey('PathVerificationState'))  { $PSBoundParameters.Add('PathVerificationState', 'Disabled'); $PathVerificationState = 'Disabled' }
        if(-not $PSBoundParameters.ContainsKey('PDORemovePeriod'))        { $PSBoundParameters.Add('PDORemovePeriod',        20);        $PDORemovePeriod = 20 }
        if(-not $PSBoundParameters.ContainsKey('RetryCount'))             { $PSBoundParameters.Add('RetryCount',             3);         $RetryCount = 3 }
        if(-not $PSBoundParameters.ContainsKey('RetryInterval'))          { $PSBoundParameters.Add('RetryInterval',          1);         $RetryInterval = 1 }
        if(-not $PSBoundParameters.ContainsKey('DiskTimeout'))            { $PSBoundParameters.Add('DiskTimeout',            60);        $DiskTimeout = 60 }
        if(-not $PSBoundParameters.ContainsKey('UseCustomPathRecovery'))  { $PSBoundParameters.Add('UseCustomPathRecovery', 'Disabled'); $UseCustomPathRecovery = 'Disabled' }
        if(-not $PSBoundParameters.ContainsKey('CustomPathRecovery'))     { $PSBoundParameters.Add('CustomPathRecovery',     40);        $CustomPathRecovery = 40 }
    }

    $settings = Get-MPIOSettingProper
    
    Write-Verbose 'Looking up PathVerificationPeriod'
    if($PSBoundParameters.ContainsKey('PathVerificationPeriod')) {
        Write-Verbose ('Testing PathVerificationPeriod ({0} vs. {1})' -f $PathVerificationPeriod, $settings.PathVerificationPeriod)
        if($PathVerificationPeriod -ne $settings.PathVerificationPeriod) { return $false }
    }

    Write-Verbose 'Looking up PathVerificationState'
    if($PSBoundParameters.ContainsKey('PathVerificationState')) {
        Write-Verbose ('Testing PathVerificationState ({0} vs. {1})' -f $PathVerificationState, $settings.PathVerificationState)
        if($PathVerificationState -ne $settings.PathVerificationState) { return $false }
    }
    
    Write-Verbose 'Looking up PDORemovePeriod'
    if($PSBoundParameters.ContainsKey('PDORemovePeriod')) {
        Write-Verbose ('Testing PDORemovePeriod ({0} vs. {1})' -f $PDORemovePeriod, $settings.PDORemovePeriod)
        if($PDORemovePeriod -ne $settings.PDORemovePeriod) { return $false }
    }
    
    Write-Verbose 'Looking up RetryCount'
    if($PSBoundParameters.ContainsKey('RetryCount')) {
        Write-Verbose ('Testing RetryCount ({0} vs. {1})' -f $RetryCount, $settings.RetryCount)
        if($RetryCount -ne $settings.RetryCount) { return $false }
    }
    
    Write-Verbose 'Looking up RetryInterval'
    if($PSBoundParameters.ContainsKey('RetryInterval')) {
        Write-Verbose ('Testing RetryInterval ({0} vs. {1})' -f $RetryInterval, $settings.RetryInterval)
        if($RetryInterval -ne $settings.RetryInterval) { return $false }
    }
    
    Write-Verbose 'Looking up DiskTimeout'
    if($PSBoundParameters.ContainsKey('DiskTimeout')) {
        Write-Verbose ('Testing DiskTimeout ({0} vs. {1})' -f $DiskTimeout, $settings.DiskTimeoutValue)

        # thanks microsoft for making parameter and setting values different
        if($DiskTimeout -ne $settings.DiskTimeoutValue) { return $false }
    }
    
    Write-Verbose 'Looking up UseCustomPathRecovery'
    if($PSBoundParameters.ContainsKey('UseCustomPathRecovery')) {
        Write-Verbose ('Testing UseCustomPathRecovery ({0} vs. {1})' -f $UseCustomPathRecovery, $settings.UseCustomPathRecoveryTime)

        # thanks microsoft for making parameter and setting values different
        if($UseCustomPathRecovery -ne $settings.UseCustomPathRecoveryTime) { return $false }
    }
    
    Write-Verbose 'Looking up CustomPathRecovery (NewPathRecoveryInterval)'
    if($PSBoundParameters.ContainsKey('CustomPathRecovery')) {
        Write-Verbose ('Testing CustomPathRecovery ({0} vs. {1})' -f $CustomPathRecovery, $settings.CustomPathRecoveryTime) 

        # thanks microsoft for making parameter and setting values different
        if($CustomPathRecovery -ne $settings.CustomPathRecoveryTime) { return $false }
    }
    
    return $true
}


# Code for proper stolen directly from (Get-Command Get-MPIOSetting).Definition because, what
# the heck Microsoft. Why do you return $MPIOSettingsOBJ | FL ?? 
function Get-MPIOSettingProper {
    Write-Verbose 'Get-MPIOSettingProper'

    $DiskTimeoutValue = (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\Disk\").TimeOutValue
    $DSMKey  = "HKLM:\System\CurrentControlSet\Services\MSDSM\Parameters"
    $MPIOKey = "HKLM:\System\CurrentControlSet\Services\mpio\Parameters"

    #Query registry values for keys under MSDSM/Parameters
    $PDORemovePeriod                 = (get-itemproperty $DSMKey -ErrorAction  "silentlycontinue").PDORemovePeriod
    $RetryCount                      = (get-itemproperty $DSMKey -ErrorAction  "silentlycontinue").RetryCount
    $RetryInterval                   = (get-itemproperty $DSMKey -ErrorAction  "silentlycontinue").RetryInterval
    $PathVerificationPeriod          = (get-itemproperty $DSMKey -ErrorAction  "silentlycontinue").PathVerificationPeriod
    $PathVerificationState           = (get-itemproperty $DSMKey -ErrorAction  "silentlycontinue").PathVerifyEnabled

    # Query values that are under MPIO/Parameters
    $UseCustomPathRecoveryInterval   = (get-itemproperty $MPIOKey -ErrorAction "silentlycontinue").UseCustomPathRecoveryInterval
    $PathRecoveryInterval            = (get-itemproperty $MPIOKey -ErrorAction "silentlycontinue").PathRecoveryInterval

    # Check to see if any of the above values are null, which indicates they are still set to defaults.
    # If they are still set to default values, then get the values from the default registry key location
    # so that the display from a get operation does not return blank values for the default settings.

    if ($PDORemovePeriod -eq $Null)
    {
        $PDORemovePeriod = (Get-ItemProperty $MPIOKey -ErrorAction  "silentlycontinue").PDORemovePeriod
    }

    if ($RetryCount -eq $Null)
    {
        $RetryCount = (Get-ItemProperty $MPIOKey -ErrorAction  "silentlycontinue").RetryCount
    }

    if ($RetryInterval -eq $Null)
    {
        $RetryInterval = (Get-ItemProperty $MPIOKey -ErrorAction  "silentlycontinue").RetryInterval
    }

    if ($PathVerificationPeriod -eq $Null)
    {
        $PathVerificationPeriod = (Get-ItemProperty $MPIOKey -ErrorAction  "silentlycontinue").PathVerificationPeriod
    }

    if ($PathVerificationState -eq $Null)
    {
        $PathVerificationState = (Get-ItemProperty $MPIOKey -ErrorAction  "silentlycontinue").PathVerifyEnabled
    }

    # Convert UseCustomPathrecoveryInterval, from a decimal to string value
    if ($PathVerificationState -eq "0")
    {
        $PathVerifycationState = "Disabled"
    }

    if ($PathVerificationState -eq "1")
    {
        $PathVerifycationState  = "Enabled"
    }

    #Convert PathVerifyEnabled from a decimal to a string value
    if ($UseCustomPathRecoveryInterval -eq "0")
    {
        $CustomPathRecoverySetting = "Disabled"
    }

    if ($UseCustomPathRecoveryInterval -eq "1")
    {
        $CustomPathRecoverySetting = "Enabled"
    }



    # Assemble the output object
    $MPIOSettingsOBJ = New-Object "Object"
    $MPIOSettingsOBJ | Add-Member "PathVerificationState"     -Value $PathVerifycationState     -MemberType "NoteProperty";
    $MPIOSettingsOBJ | Add-Member "PathVerificationPeriod"    -Value $PathVerificationPeriod    -MemberType "NoteProperty";    
    $MPIOSettingsOBJ | Add-Member "PDORemovePeriod"           -Value $PDORemovePeriod           -MemberType "NoteProperty";
    $MPIOSettingsOBJ | Add-Member "RetryCount"                -Value $RetryCount                -MemberType "NoteProperty";
    $MPIOSettingsOBJ | Add-Member "RetryInterval"             -Value $RetryInterval             -MemberType "NoteProperty";
    $MPIOSettingsOBJ | Add-Member "UseCustomPathRecoveryTime" -Value $CustomPathRecoverySetting -MemberType "NoteProperty";
    $MPIOSettingsOBJ | Add-Member "CustomPathRecoveryTime"    -Value $PathRecoveryInterval      -MemberType "NoteProperty";
    $MPIOSettingsOBJ | Add-Member "DiskTimeoutValue"          -Value $DiskTimeoutValue          -MemberType "NoteProperty";

    return $MPIOSettingsOBJ
}


# Code for proper stolen directly from (Get-Command Set-MPIOSetting).Definition because, what
# the heck Microsoft. Why does your script say the default values are out of range??
function Set-MPIOSettingProper {
    [CmdletBinding()]
    param(
        [parameter(Mandatory=$false)]
        [ValidateRange(1,9999)]
        [INT]$NewPathVerificationPeriod,

        [parameter(Mandatory=$false)]
        [ValidateSet("Enabled","Disabled")]
        [String]$NewPathVerificationState,

        [parameter(Mandatory=$false)]
        [ValidateRange(10,9999)]
        [INT]$NewPDORemovePeriod,

        [parameter(Mandatory=$false)]
        [ValidateRange(3,9999)]
        [INT]$NewRetryCount,

        [parameter(Mandatory=$false)]
        [ValidateRange(1,9999)]
        [INT]$NewRetryInterval,

        [parameter(Mandatory=$false)]
        [ValidateRange(10,100)]
        [INT]$NewDiskTimeout,

        [parameter(Mandatory=$false)]
        [ValidateSet("Enabled","Disabled")]
        [String]$CustomPathRecovery,

        [parameter(Mandatory=$false)]
        [ValidateRange(10,9999)]
        [INT]$NewPathRecoveryInterval
    )

    Write-Verbose 'Set-MPIOSettingProper'

    # Set appropriate registry keys for later use.
    $DSMKey  = "HKLM:\System\CurrentControlSet\Services\MSDSM\Parameters"
    $MPIOKey = "HKLM:\System\CurrentControlSet\Services\MPIO\Parameters"
    $DiskTimeoutRegistryKey  = "HKLM:\SYSTEM\CurrentControlSet\Services\Disk\"

    #Convert CustomPathRecovery setting to decimal for use with registry
    if ($CustomPathRecovery -eq "Enabled")
    {
        [int16]$CustomPathSetting = "1"
    }

    if ($CustomPathRecovery -eq "Disabled")
    {
        [int16]$CustomPathSetting = "0"
    }


    #Convert PathVerifyEnabled
    if ($NewPathVerificationState -eq "Enabled")
    {
        [int16]$PathVerifyState = "1"
    }

    if ($NewPathVerificationState -eq "Disabled")
    {
        [int16]$PathVerifyState  = "0"
    }


    # If any parameters were passed, make the necessary changes.
    if (
           ($NewPathVerificationPeriod)   -or
           ($NewPathVerificationState)    -or
           ($NewPDORemovePeriod)          -or
           ($NewRetryCount)               -or
           ($NewRetryInterval)            -or
           ($CustomPathSetting -ne $Null) -or
           ($NewPathRecoveryInterval)     -or
           ($NewDiskTImeout)
       )
    {

        If ($NewPathVerificationPeriod)
        {
            Set-ItemProperty -Path $DSMKey  -Name "PathVerificationPeriod"        -value $NewPathVerificationPeriod
        }
        If ($NewPDORemovePeriod)
        {
            Set-ItemProperty -Path $DSMKey  -Name "PDORemovePeriod"               -value $NewPDORemovePeriod
        }
        If ($NewRetryCount)
        {
            Set-ItemProperty -Path $DSMKey  -Name "RetryCount"                    -value $NewRetryCount
        }
        If ($NewRetryInterval)
        {
            Set-ItemProperty -Path $DSMKey  -Name "RetryInterval"                 -value $NewRetryInterval
        }

        If ($PathVerifyState -ne $Null)
        {
            Set-ItemProperty -Path $DSMKey  -Name "PathVerifyEnabled"             -value $PathVerifyState
        }
        If ($NewPathRecoveryInterval)
        {
            Set-ItemProperty -Path $MPIOKey -Name "PathRecoveryInterval"          -value $NewPathRecoveryInterval
        }
        If ($CustomPathSetting -ne $Null)
        {
            Set-ItemProperty -Path $MPIOKey -Name "UseCustomPathRecoveryInterval" -value $CustomPathSetting
        }

        If ($NewDiskTimeout)
        {
            Set-ItemProperty -Path $DiskTimeoutRegistryKey  -Name "TimeoutValue" -value $NewDiskTimeout
        }

        Write-Warning "Settings changed, reboot required"

    }
    else
    {
    Write-Verbose "No settings have been changed"
    }
}




Export-ModuleMember -function Get-TargetResource, Set-TargetResource, Test-TargetResource