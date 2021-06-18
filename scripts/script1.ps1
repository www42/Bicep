# Install IIS and create simple home page
Install-WindowsFeature -name Web-Server -IncludeManagementTools 
Remove-Item 'C:\inetpub\wwwroot\\iisstart.htm'
Add-Content -Path 'C:\inetpub\wwwroot\iisstart.htm' -Value $('Hello World from ' + $env:computername)