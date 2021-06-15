Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module -Name az -Force

$source1 = 'https://raw.githubusercontent.com/www42/AZ-303-Microsoft-Azure-Architect-Technologies/master/tj/demo-managed-ID/ARM.ps1'
$destination1 =  "$HOME\Desktop\ARM.ps1"
Invoke-WebRequest -Uri $source1 -OutFile $destination1

$source2 = 'https://raw.githubusercontent.com/www42/AZ-303-Microsoft-Azure-Architect-Technologies/master/tj/demo-managed-ID/PowerShell.ps1'
$destination2 =  "$HOME\Desktop\PowerShell.ps1"
Invoke-WebRequest -Uri $source2 -OutFile $destination2