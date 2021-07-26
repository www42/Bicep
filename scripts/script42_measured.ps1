# Install NuGet in order to install modules
Write-Output 'Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force'
Measure-Command -Expression {Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force}

# Install more DSC resources e.g. 'TimeZone'
Write-Output 'Install-Module -Name ComputerManagementDsc -Force'
Measure-Command -Expression {Install-Module -Name ComputerManagementDsc -Force}

# Install Module Az
Write-Output 'Install-Module -Name az -Force'
Measure-Command -Expression {Install-Module -Name az -Force}

# Create temp folder
# (Azure VM custom script extension cannot use user profile as destination, C:\Users\Student does not exist at that time)
Write-Output 'New-Item -ItemType Directory -Path C:\temp -Force'
Measure-Command -Expression {New-Item -ItemType Directory -Path C:\temp -Force}

# Download files for demo "Managed Identity"
$source1 = 'https://raw.githubusercontent.com/www42/AZ-303-Microsoft-Azure-Architect-Technologies/master/tj/demo-Mi/demo-Mi-Token.ps1'
$destination1 =  'C:\temp\demo-Mi-Token.ps1'
Write-Output 'Invoke-WebRequest -Uri $source1 -OutFile $destination1'
Measure-Command -Expression {Invoke-WebRequest -Uri $source1 -OutFile $destination1}

$source2 = 'https://raw.githubusercontent.com/www42/AZ-303-Microsoft-Azure-Architect-Technologies/master/tj/demo-Mi/demo-Mi-AzContext.ps1'
$destination2 =  'C:\temp\demo-Mi-AzContext.ps1'
Write-Output 'Invoke-WebRequest -Uri $source2 -OutFile $destination2'
Measure-Command -Expression {Invoke-WebRequest -Uri $source2 -OutFile $destination2}

# Download Edge browser installer
$source3 = 'https://download69118.blob.core.windows.net/anon/MicrosoftEdgeEnterpriseX64.msi'
$destination3 = 'C:\temp\MicrosoftEdgeEnterpriseX64.msi'
Write-Output 'Invoke-WebRequest -Uri $source3 -OutFile $destination3'
Measure-Command -Expression {Invoke-WebRequest -Uri $source3 -OutFile $destination3}

# Download zoomit ver 4.50 (works with pen)
$source4 = 'https://download69118.blob.core.windows.net/anon/ZoomIt.exe'
$destination4 = 'C:\temp\ZoomIt.exe'
Write-Output 'Invoke-WebRequest -Uri $source4 -OutFile $destination4'
Measure-Command -Expression {Invoke-WebRequest -Uri $source4 -OutFile $destination4}

# Download CpuStress
$source5 = 'https://download.sysinternals.com/files/CPUSTRES.zip'
$destination5 = 'C:\temp\CPUSTRES.zip'
Write-Output 'Invoke-WebRequest -Uri $source5 -OutFile $destination5'
Measure-Command -Expression {Invoke-WebRequest -Uri $source5 -OutFile $destination5}