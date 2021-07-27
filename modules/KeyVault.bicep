param kvName string = 'KeyVault'
param location string = resourceGroup().location
param tenantId string = subscription().tenantId
param allPermissionsUserObjectId string

resource kv 'Microsoft.KeyVault/vaults@2021-04-01-preview' = {
  name: kvName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenantId
    accessPolicies: [
      {
        tenantId: tenantId
        objectId: allPermissionsUserObjectId
        permissions: {
          secrets: [
            'backup'
            'delete'
            'get'
            'list'
            'purge'
            'recover'
            'restore'
            'set'
          ]
          keys: [
            'backup'
            'create'
            'decrypt'
            'delete'
            'encrypt'
            'get'
            'import'
            'list'
            'purge'
            'recover'
            'release'
            'restore'
            'sign'
            'unwrapKey'
            'update'
            'verify'
            'wrapKey'
          ]
          certificates: [
            'backup'
            'create'
            'delete'
            'deleteissuers'
            'get'
            'getissuers'
            'import'
            'list'
            'listissuers'
            'managecontacts'
            'manageissuers'
            'purge'
            'recover'
            'restore'
            'setissuers'
            'update'
          ]
        }
      }
    ]
  }
}
