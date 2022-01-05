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
function Import-ContosoAzureADUsers {
<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Long description
.EXAMPLE
    Example of how to use this cmdlet
.EXAMPLE
    Another example of how to use this cmdlet
.INPUTS
    Inputs to this cmdlet (if any)
.OUTPUTS
    Output from this cmdlet (if any)
.NOTES
    General notes
.COMPONENT
    The component this cmdlet belongs to
.ROLE
    The role this cmdlet belongs to
.FUNCTIONALITY
    The functionality that best describes this cmdlet
#>
    [CmdletBinding()]        
    Param (
        [Parameter(Mandatory=$false)]
        [string]
        $Path = "$PSScriptRoot/ContosoAzureADUsers.csv"
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
            Write-Host "User exists $UserPrincipalName"
        }
    }
}
function Remove-ContosoImportedAzureADUsers {

<#
    .SYNOPSIS
        Short description
    .DESCRIPTION
        Long description
    .EXAMPLE
        Example of how to use this cmdlet
    .EXAMPLE
        Another example of how to use this cmdlet
    .INPUTS
        Inputs to this cmdlet (if any)
    .OUTPUTS
        Output from this cmdlet (if any)
    .NOTES
        General notes
    .COMPONENT
        The component this cmdlet belongs to
    .ROLE
        The role this cmdlet belongs to
    .FUNCTIONALITY
        The functionality that best describes this cmdlet
#>
    [CmdletBinding()]    
    Param (
        [Parameter(Mandatory=$false)]
        [string]
        $Path = "$PSScriptRoot/ContosoAzureADUsers.csv"
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
            Write-Warning "User $UserPrincipalName does not exist."
        }
        catch {
            Write-Warning "An error occoured."
        }
    }
}
