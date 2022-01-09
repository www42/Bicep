# Guest User können genauso berechtigt werden wie Member User
#   Ja, aber Standard ist 'Beschränkter Zugriff'
#   [Einschränken der Zugriffsberechtigungen für Gastbenutzer – Azure Active Directory | Microsoft Docs](https://docs.microsoft.com/de-de/azure/active-directory/enterprise-users/users-restrict-guest-permissions)

# Password policy on prem sync to AzureAD
#   [Sync ad password policy to azure ad - Microsoft Q&A](https://docs.microsoft.com/en-us/answers/questions/102184/sync-ad-password-policy-to-azure-ad.html)

# Unfamiliar locations (ID protection)
#   [Standortbedingung beim bedingten Zugriff in Azure Active Directory | Microsoft Docs](https://docs.microsoft.com/de-de/azure/active-directory/conditional-access/location-condition)

# PIM automatisch approved nach dem ersten approvement
#   ?

# UAA kann keinen Ownern erzeugen?
#   Stimmt nicht.
Get-AzRoleDefinition -Name "User Access Administrator"

# 2x RBAC
#   war nicht so eindeutig

# Key vault
#  PFX/PEM bedeutet nicht mit/ohne private key
# [Aktivieren des vorläufigen Löschens für alle Schlüsseltresorobjekte: Azure Key Vault | Microsoft Docs](https://docs.microsoft.com/de-de/azure/key-vault/general/soft-delete-change)

# SMB Zugriff für AzureAD Member geht
#   wirklich?
# B2C Identitäten können keine RBAC Rolle bekonnen


$PSVersionTable | % PSVersion | % Major
Get-Module -ListAvailable -Name AzureAD
Import-Module -Name AzureAD
Connect-AzureAD
Get-AzureADMSRoleDefinition -Id 17315797-102d-40b4-93e0-432062caca18 | % RolePermissions | ConvertTo-Json 

# OData 3.0 Filter
Get-AzureADMSRoleDefinition -Filter "startswith(DisplayName,'Compliance')" | % DisplayName

# Storage SAS mit access policy
Get-Module -ListAvailable -Name Az.Storage

Login-AzAccount
$Location = "westeurope"
$RgName = "Storage-RG"
New-AzResourceGroup -Name $RgName -Location $Location
Get-AzStorageAccount
New-AzStorageAccount -Name "tm$(Get-Random)" -ResourceGroupName

# AZ-500 Lab 13
New-AzResourceGroup -Name AZ500LAB131415 -Location 'EastUS'
New-AzVm -ResourceGroupName "AZ500LAB131415" -Name "myVM" -Location 'EastUS' -VirtualNetworkName "myVnet" -SubnetName "mySubnet" -SecurityGroupName   "myNetworkSecurityGroup" -PublicIpAddressName "myPublicIpAddress" -OpenPorts 80,3389



# https://microsoftlearning.github.io/SC-200T00A-Microsoft-Security-Operations-Analyst/