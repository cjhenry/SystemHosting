configuration example {
    Import-DscResource -Module SYSTEMHOSTING

    Node 'localhost' {
    

        # A module for configuring MPIO settings, fx. retry and timeout values.
        # This module requires the MPIO WindowsFeature.
        # To get the current MPIO settings, run the following command:
        #   Get-MPIOSetting
        # All changes to MPIO settings require a reboot before taking effect.
        # The settings, as listed, are the default values on a Windows Server 2012 R2 installation.

        cMPIOSetting mpioSetting {
            EnforceDefaults = $true
            PathVerificationState = 'Disabled'
            PathVerificationPeriod = 30
            PDORemovePeriod = 20
            RetryCount = 3
            RetryInterval = 1
            UseCustomPathRecovery = 'Disabled'
            CustomPathRecovery = 40
        }
    }
}