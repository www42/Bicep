// Bastion Host
param location string = resourceGroup().location

param bastionName string = 'Bastion1'
param bastionSubnetId string

resource bastion 'Microsoft.Network/bastionHosts@2020-11-01' = {
  name: bastionName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipConfig1'
        properties: {
          publicIPAddress: {
            id: bastionPip.id
          }
          subnet: {
            id: bastionSubnetId
          }
        }
      }
    ] 
  }
}
resource bastionPip 'Microsoft.Network/publicIPAddresses@2020-11-01' = {
  name: '${bastionName}-Pip'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}
