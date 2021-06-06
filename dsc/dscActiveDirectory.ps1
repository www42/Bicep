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