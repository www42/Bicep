# -----------------------------------------
# Don't forget to update all.zip
#              to commit all.zip to GitHub
# -----------------------------------------

# This is the combination of following configs (copied from dscConfigs.ps1)
#     SetTimeZone
#     DoNotOpenServerManagerAtLogon
#     popupTryWacOff
#     ieSecurityOff

Configuration config33 { 
    Import-DSCResource -ModuleName ComputerManagementDsc
    node ("localhost") {
        TimeZone Berlin {
            IsSingleInstance = "Yes"
            TimeZone         = "W. Europe Standard Time"
        }   
        Registry DoNotOpenServerManagerAtLogon {
            Ensure    = "Present"
            Key       = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\ServerManager"
            ValueName = "DoNotOpenServerManagerAtLogon"
            ValueType = "Dword"
            ValueData = [int]1
        }
        Registry popupTryWacOff {
            Ensure    = "Present"
            Key       = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\ServerManager"
            ValueName = "DoNotPopWACConsoleAtSMLaunch"
            ValueType = "Dword"
            ValueData = [int]1
        }
        Registry ieSecurityAdminOff {
            Ensure    = "Present"
            Key       = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
            ValueName = "IsInstalled"
            ValueType = "Dword"
            ValueData = [int]0
        }
        Registry ieSecurityUserOff {
            Ensure    = "Present"
            Key       = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
            ValueName = "IsInstalled"
            ValueType = "Dword"
            ValueData = [int]0
        }
    }
}