# Import-Module -Name AzureAD                   # on WindowsPowershell
Import-Module -Name AzureAD.Standard.Preview    # on PowerShell 7
Connect-AzureAD
Get-AzureADDomain
Get-Module -ListAvailable -Name Az.Resources
Import-Module -Name /Users/tj/git/Bicep/scenarios/Trainymotion/Tm/Tm.psd1 -Force
Get-Module -Name Tm

# Users
Get-AzureADUser
Import-TmAzureADUser
Remove-TmImportedAzureADUser

# Groups
Get-AzureADGroup
Get-AzureADGroup -Filter "DisplayName eq 'Theoretical Physics'" | % ObjectId | Remove-AzureADGroup
Remove-AzureADGroup -ObjectId "foo"
Import-TmAzureADGroup
Remove-TmImportedAzureADGroup


Add-AzADGroupMember -MemberObjectId (Get-AzureADUser | Where-Object DisplayName -Like "Erwin Schrödinger").ObjectId -TargetGroupObjectId $AzureADGroup.ObjectId

Remove-AzureADGroup -ObjectId $AzureADGroup.ObjectId