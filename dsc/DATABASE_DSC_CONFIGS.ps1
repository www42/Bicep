# This file is the place where all DSC configs are collected.
# Grab all resources you need e.g.
#
#        Registry foo {}
#        Registry bar {}
#        TimeZone Berlin {}
#
# and merge them into a new single(!) configuration
#
#        Configuration myconfig {
#           node ("localhost") {
#              Registry foo {}
#              Registry bar {}
#              TimeZone Berlin {}
#           }
#        }
#        
# Save this as 'config123.ps1'
#
# 'config123.ps1' will be included in 'allConfigs.zip' by running 'createZip.sh'
# ------------------------------------------------------------------------------
Configuration SetTimeZone {
   Import-DSCResource -ModuleName ComputerManagementDsc  # Be sure this module has been made available by custom script
   node ("localhost") {
       TimeZone Berlin {
           IsSingleInstance = "Yes"
           TimeZone         = "W. Europe Standard Time"
       }
   }
}
Configuration DoNotOpenServerManagerAtLogon {
   node ("localhost"){
      Registry DoNotOpenServerManagerAtLogon {
         Ensure    = "Present"
         Key       = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\ServerManager"
         ValueName = "DoNotOpenServerManagerAtLogon"
         ValueType = "Dword"
         ValueData = [int]1
      }
   }
}
Configuration windowsFirewallOff {
   node ("localhost") {
      Registry windowsFirewallDomainOff {
         Ensure    = "Present"
         Key       = "HKLM:\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile"
         ValueName = "EnableFirewall"
         ValueType = "Dword"
         ValueData = [int]0
      }
      Registry windowsFirewallPrivateOff {
         Ensure    = "Present"
         Key       = "HKLM:\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile"
         ValueName = "EnableFirewall"
         ValueType = "Dword"
         ValueData = [int]0
      }
      Registry windowsFirewallPublicOff {
         Ensure    = "Present"
         Key       = "HKLM:\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\PublicProfile"
         ValueName = "EnableFirewall"
         ValueType = "Dword"
         ValueData = [int]0
      }
   }
}
Configuration ieSecurityOff {
   node ("localhost") {
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
Configuration popupTryWacOff {
   node ("localhost") {
      Registry popupTryWacOff {
         Ensure    = "Present"
         Key       = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\ServerManager"
         ValueName = "DoNotPopWACConsoleAtSMLaunch"
         ValueType = "Dword"
         ValueData = [int]1
      }
   }
}
Configuration installRRAS {
   node ("localhost") {
      WindowsFeature RemoteAccess {
         Name   = "RemoteAccess"
         Ensure = "Present"
      }
      WindowsFeature RSAT-RemoteAccess {
         Name   = "RSAT-RemoteAccess"
         Ensure = "Present"
      }
      WindowsFeature Routing {
         Name   = "Routing"
         Ensure = "Present"
      }
   }
}
Configuration ADDomain_NewForest {
   [CmdletBinding()]
   param (
      [Parameter(Mandatory = $true)]
      [ValidateNotNullOrEmpty()]
      [string]
      $DomainName,
      
      [Parameter(Mandatory = $true)]
      [ValidateNotNullOrEmpty()]
      [string]
      $DomainAdminName,

      [Parameter(Mandatory = $true)]
      [ValidateNotNullOrEmpty()]
      [string]
      $DomainAdminPassword
   )
   Import-DscResource -ModuleName ActiveDirectoryDsc

   $SecurePW = ConvertTo-SecureString -String $DomainAdminPassword -AsPlainText -Force
   $Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $DomainAdminName,$SecurePW

   node ("localhost") {
      WindowsFeature ADDS {
         Name   = "AD-Domain-Services"
         Ensure = "Present"
      }
      WindowsFeature RSAT {
         Name   = "RSAT-AD-Tools"
         Ensure = "Present"
         IncludeAllSubFeature = $true
      }
      ADDomain ADDomain {
         DomainName                    = $DomainName
         Credential                    = $Credential
         SafemodeAdministratorPassword = $Credential
         ForestMode                    = 'WinThreshold'
      }
   }
}