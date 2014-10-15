configuration example {
    Import-DscResource -Module SYSTEMHOSTING

    Node 'localhost' {
 
        # A resource for white-listing allowed services. Writes an eventlog warning if an unlisted service is running. The warning is:
        #  Application\AllowedServices DSC resource - Event ID 1

        cAllowedServices allowedServices { 
            EnforceList = $true
            EventSource = 'SHT_AllowedServices DSC resource'
            EventLog = 'Application'
            Services = @(
                'Appinfo'               #Application Information
                'BFE'                   #Base Filtering Engine
                'BITS'                  #Background Intelligent Transfer Service
                'BrokerInfrastructure'  #Background Tasks Infrastructure Service
                'CcmExec'               #System Center Configuration Manager agent
                'CryptSvc'              #Cryptographic Services
                'DcomLaunch'            #DCOM Server Process Launcher
                'Dhcp'                  #DHCP Client
                'Dnscache'              #DNS Client
                'EventLog'              #Windows Event Log
                'EventSystem'           #COM+ Event System
                'gpsvc'                 #Group Policy Client
                'HealthService'         #System Center Operations Manager agent
                'hidserv'               #Human Interface Device Service
                'iphlpsvc'              #IP Helper
                'KeyIso'                #CNG Key Isolation
                'LanmanServer'          #Server
                'LanmanWorkstation'     #Workstation
                'lmhosts'               #TCP/IP NetBIOS Helper
                'LSM'                   #Local Session Manager
                'MpsSvc'                #Windows Firewall
                'MsMpSvc'               #Microsoft Antimalware Protection
                'MSDTC'                 #Distributed Transaction Coordinator
                'Netlogon'              #Netlogon
                'Netman'                #Network Connections
                'netprofm'              #Network List Service
                'NlaSvc'                #Network Location Awareness
                'nsi'                   #Network Store Interface Service
                'PlugPlay'              #Plug and Play
                'PolicyAgent'           #IPsec Policy Agent
                'Power'                 #Power
                'ProfSvc'               #User Profile Service
                'RemoteRegistry'        #Remote Registry
                'RpcEptMapper'          #RPC Endpoint Mapper
                'RpcSs'                 #Remote Procedure Call (RPC)
                'SamSs'                 #Security Accounts Manager
                'ScDeviceEnum'          #Smart Card Device Enumeration Service
                'Schedule'              #Task Scheduler
                'SCVMMAgent'            #System Center Virtual Machine Manager Agent
                'SENS'                  #System Event Notification Service
                'SessionEnv'            #Remote Desktop Configuration
                'ShellHWDetection'      #Shell Hardware Detection
                'SystemEventsBroker'    #System Events Broker
                'TermService'           #Remote Desktop Services
                'Themes'                #Themes
                'TrkWks'                #Distributed Link Tracking Client
                'UALSVC'                #User Access Logging Service
                'vds'                   #Virtual Disk
                'vmms'                  #Hyper-V Virtual Machine Management
                'W32Time'               #Windows Time
                'Wcmsvc'                #Windows Connection Manager
                'Winmgmt'               #Windows Management Instrumentation
                'WinRM'                 #Windows Remote Management (WS-Management)
                'wmiApSrv'              #WMI Performance Adapter
            )
        }
    }
}