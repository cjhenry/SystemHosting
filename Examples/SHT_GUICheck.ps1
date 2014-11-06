configuration example {
    Import-DscResource -Module SYSTEMHOSTING

    Node 'localhost' {
 
        # A resource for detecting and, if Enforce is $true, removing the GUI from a Windows Server installation
        # Writes an eventlog entry if the GUI is detected, and another if it is removed.

        # Detected has EventID 1, Removed has EventID 2.


        cGUICheck guiCheck {
            Enforce = $true
            EventLog = 'Application'
            EventSource = 'SHT_GUICheck DSC resource'
        }
    }
}