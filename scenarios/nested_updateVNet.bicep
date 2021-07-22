param virtualNetwork object

resource VNet 'Microsoft.Network/virtualNetworks@2016-03-30' = {
  name: 'VNet'
  location: resourceGroup().location
  properties: {
    addressSpace: virtualNetwork.addressSpace
    subnets: [
      {
        name: virtualNetwork.subnets[0].name
        properties: {
          addressPrefix: virtualNetwork.subnets[0].properties.addressPrefix
        }
      }
      {
        name: 'secondSubnet'
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
    ]
  }
}
