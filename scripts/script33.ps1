# Install DSC resource 'TimeZone' and more
Install-Module -Name ComputerManagementDsc -Force

# Install Module Az
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module -Name az -Force

# Create temp folder
# (Azure VM custom script extension cannot use user profile as destination, C:\Users\Student does not exist at that time)
New-Item -ItemType Directory -Path C:\temp -Force

# Download files for demo "Managed Identity"
$source1 = 'https://raw.githubusercontent.com/www42/AZ-303-Microsoft-Azure-Architect-Technologies/master/tj/demo-Mi/demo-Mi-Token.ps1'
$destination1 =  'C:\temp\demo-Mi-Token.ps1'
Invoke-WebRequest -Uri $source1 -OutFile $destination1

$source2 = 'https://raw.githubusercontent.com/www42/AZ-303-Microsoft-Azure-Architect-Technologies/master/tj/demo-Mi/demo-Mi-AzContext.ps1'
$destination2 =  'C:\temp\demo-Mi-AzContext.ps1'
Invoke-WebRequest -Uri $source2 -OutFile $destination2

# Download Edge browser installer
$source3 = 'https://download69118.blob.core.windows.net/anon/MicrosoftEdgeEnterpriseX64.msi'
$destination3 = 'C:\temp\MicrosoftEdgeEnterpriseX64.msi'
Invoke-WebRequest -Uri $source3 -OutFile $destination3

# Download zoomit ver 4.50 (works with pen)
$source4 = 'https://download69118.blob.core.windows.net/anon/ZoomIt.exe'
$destination4 = 'C:\temp\ZoomIt.exe'
Invoke-WebRequest -Uri $source4 -OutFile $destination4

# Download CpuStress
$source5 = 'https://download.sysinternals.com/files/CPUSTRES.zip'
$destination5 = 'C:\temp\CPUSTRES.zip'
Invoke-WebRequest -Uri $source5 -OutFile $destination5