# Password policy on prem sync to AzureAD
# [Sync ad password policy to azure ad - Microsoft Q&A](https://docs.microsoft.com/en-us/answers/questions/102184/sync-ad-password-policy-to-azure-ad.html)

# unfamiliar locations
# Russland, Norkkorea

# PIM automatisch approved?

$PSVersionTable | % PSVersion | % Major
Get-Module -ListAvailable -Name AzureAD
Import-Module -Name AzureAD
Connect-AzureAD
Get-AzureADMSRoleDefinition -Id 17315797-102d-40b4-93e0-432062caca18 | % RolePermissions | ConvertTo-Json 

# OData 3.0 Filter
Get-AzureADMSRoleDefinition -Filter "startswith(DisplayName,'Compliance')" | % DisplayName

# UAA kann keinen Ownern erzeugen?
Get-AzRoleDefinition -Name "User Access Administrator"