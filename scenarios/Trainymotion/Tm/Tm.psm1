function Remove-StringDiacritic {

<#
.SYNOPSIS
    This function will remove the diacritics (accents) characters from a string.

.DESCRIPTION
    This function will remove the diacritics (accents) characters from a string.

.PARAMETER String
    Specifies the String(s) on which the diacritics need to be removed

.PARAMETER NormalizationForm
    Specifies the normalization form to use
    https://msdn.microsoft.com/en-us/library/system.text.normalizationform(v=vs.110).aspx

.EXAMPLE
    PS C:\> Remove-StringDiacritic "L'été de Raphaël"

    L'ete de Raphael

.NOTES
    Francois-Xavier Cat
    @lazywinadmin
    lazywinadmin.com
    github.com/lazywinadmin
#>
    [CMdletBinding()]
    PARAM
    (
        [ValidateNotNullOrEmpty()]
        [Alias('Text')]
        [System.String[]]$String,
        [System.Text.NormalizationForm]$NormalizationForm = "FormD"
    )

    FOREACH ($StringValue in $String) {
        # Write-Verbose -Message "$StringValue"
        try {
            # Normalize the String
            $Normalized = $StringValue.Normalize($NormalizationForm)
            $NewString = New-Object -TypeName System.Text.StringBuilder

            # Convert the String to CharArray
            $normalized.ToCharArray() |
                ForEach-Object -Process {
                    if ([Globalization.CharUnicodeInfo]::GetUnicodeCategory($psitem) -ne [Globalization.UnicodeCategory]::NonSpacingMark) {
                        [void]$NewString.Append($psitem)
                    }
                }

            #Combine the new string chars
            Write-Output $($NewString -as [string])
        }
        Catch {
            Write-Error -Message $Error[0].Exception.Message
        }
    }
}
function Import-TmAzureADUser {
    [CmdletBinding()]        
    param (
        [Parameter(Mandatory=$false)]
        [string]
        $Path = "$PSScriptRoot/TmAzureADUsers.csv"
    )
    $Users = Import-Csv -Path $Path
    $DomainName = ((Get-AzureAdTenantDetail).VerifiedDomains)[0].Name
    $PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
    $PasswordProfile.Password = 'Pa55w.rd1234'

    foreach ($User in $Users) {
        $GivenName         = $User.GivenName
        $Surname           = $User.Surname    
        $DisplayName       = "$GivenName $Surname"
        $UserPrincipalName = Remove-StringDiacritic -String "$GivenName.$Surname@$DomainName"
        $MailNickName      = $GivenName
        $TelephoneNumber   = $User.TelephoneNumber
        $CompanyName       = $User.CompanyName
        $EmployeeId        = $User.EmployeeId
        $UsageLocation     = $User.UsageLocation
        $City              = $User.City
        $Country           = $User.Country
        $Department        = $User.Department
        $JobTitle          = $User.JobTitle

        $ExtensionProperty = New-Object -TypeName System.Collections.Generic.Dictionary"[String,String]"
        $ExtensionProperty.Add('employeeId',$EmployeeId)
        $ExtensionProperty.Add('CompanyName',$CompanyName)

        if (!(Get-AzureADUser -Filter "userPrincipalName eq '$UserPrincipalName'")) {
            Write-Verbose "Creating $UserPrincipalName"
            New-AzureADUser `
            -GivenName $GivenName `
            -Surname $Surname `
            -DisplayName $DisplayName `
            -UserPrincipalName $UserPrincipalName `
            -MailNickName $MailNickName `
            -TelephoneNumber $TelephoneNumber `
            -UsageLocation $UsageLocation `
            -City $City `
            -Country $Country `
            -Department $Department `
            -JobTitle $JobTitle `
            -PasswordProfile $passwordProfile `
            -ExtensionProperty $ExtensionProperty `
            -AccountEnabled $true
        }
        else {
            Write-Warning "User exists $UserPrincipalName"
        }
    }
}
function Remove-TmImportedAzureADUser {
    [CmdletBinding()]    
    param (
        [Parameter(Mandatory=$false)]
        [string]
        $Path = "$PSScriptRoot/TmAzureADUsers.csv"
    )
    $Users = Import-Csv -Path $Path
    $DomainName = ((Get-AzureAdTenantDetail).VerifiedDomains)[0].Name

    foreach ($User in $Users) {
        $GivenName         = $User.GivenName
        $Surname           = $User.Surname    
        $UserPrincipalName = Remove-StringDiacritic -String "$GivenName.$Surname@$DomainName"

        try {
            Write-Verbose "Removing user $UserPrincipalName"
            Remove-AzureADUser -ObjectId $UserPrincipalName
            Write-Output "User $UserPrincipalName removed."
        }
        catch [Microsoft.Open.AzureAD16.Client.ApiException] {
            Write-Warning "User does not exist $UserPrincipalName"
        }
        catch {
            Write-Warning "An error occured."
        }
    }
}
function Import-TmAzureADGroup {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [string]
        $Path = "$PSScriptRoot/TmAzureADGroups.csv"
    )
    $Groups = Import-Csv -Path $Path
    foreach ($Group in $Groups) {
        $DisplayName  = $Group.DisplayName
        $Description  = $Group.Description
        $MailNickName = $Group.MailNickName

        if (!(Get-AzureADGroup -Filter "DisplayName eq '$DisplayName'")) {
            Write-Verbose "Creating group $DisplayName"
            New-AzureADGroup -DisplayName $DisplayName -Description $Description -MailEnabled:$false -MailNickName $MailNickName -SecurityEnabled:$true            
        }
        else {
            Write-Warning "Group exists $DisplayName"
        }        
    }
}
function Remove-TmImportedAzureADGroup {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [string]
        $Path = "$PSScriptRoot/TmAzureADGroups.csv"
    )
    $Groups = Import-Csv -Path $Path
    foreach ($Group in $Groups) {
        $DisplayName  = $Group.DisplayName
        try {
            Write-Verbose "Removing group $DisplayName"
            $ADGroup = Get-AzureADGroup -Filter "DisplayName eq '$DisplayName'"
            Remove-AzureADGroup -ObjectId $ADGroup.ObjectId
        }
        catch {
            Write-Warning "Group does not exist $DisplayName"
        }
    }
}
function Add-TmAzureADGroupMember {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]
        $MemberName,
        [Parameter(Mandatory=$true)]
        [string]
        $GroupName
        )
    
    $Group = Get-AzureADGroup -Filter "DisplayName eq '$GroupName'"
    if (!($Group)) {
        Write-Warning "Cannot add $MemberName  to  $GroupName. Group does not exist."
        return
    }

    $Member = Get-AzureADUser -Filter "DisplayName eq '$MemberName'"
    if ((!$Member)) {
        $Member = Get-AzureADGroup -Filter "DisplayName eq '$MemberName'"
    }

    try {
        Write-Verbose "--- foo ---------------"
        $foo = $Member.ObjectId
        Write-Verbose "$foo"
        Write-Verbose "--- bar ---------------"
        Write-Verbose "Adding  $MemberName  to group  $GroupName"
        Add-AzADGroupMember -MemberObjectId $Member.ObjectId -TargetGroupObjectId $Group.ObjectId -ErrorAction Stop
    }
    catch {
        Write-Warning "An error occured. (Already member?)"
    }    
}