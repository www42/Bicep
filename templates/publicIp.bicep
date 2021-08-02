param name string
param location string = resourceGroup().location

resource pip 'Microsoft.Network/publicIPAddresses@2021-02-01' = {
  name: name
  location: location
  sku: {
    name: 'Basic'
    tier: 'Regional'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Dynamic'
  }
}

output pipId string = pip.id
