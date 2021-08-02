targetScope = 'subscription'

param rgName string 
param datestring string
param allPermissionsUserObjectId string

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: deployment().location
}

// Key Vault
module kv '../../templates/keyVault.bicep' = {
  scope: rg
  name: 'kvDeployment-${datestring}'
  params: {
    kvName: 'KV-${uniqueString(rg.id)}'
    allPermissionsUserObjectId: allPermissionsUserObjectId
  }
}
