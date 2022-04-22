# 1) Request OAuth token
# ----------------------
# Use Instance Metadata Service
# See https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/how-to-use-vm-token
#
$Uri      = "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fmanagement.azure.com%2F"
$Header   = @{"Metadata" = "true"}

$response = Invoke-RestMethod -Method GET -Uri $Uri -Headers $Header -Proxy $null

$token    = $response.access_token



# 2) Use OAuth token
# ------------------
# Enumerate resources in a resource group 
# See ARM API Browser  https://docs.microsoft.com/en-us/rest/api/resources/resources/listbyresourcegroup
#
$RG = "RG-Storage"
$Subscription = "d4d6b4ab-c772-45da-80b8-24a0160d5f45"


$uri     = "https://management.azure.com/subscriptions/$Subscription/resourceGroups/$RG/resources?api-version=2021-04-01"
$Header  = @{"authorization" = "Bearer $token"}

$response = Invoke-RestMethod -Method Get -Uri $Uri -Headers $Header

$response.value
