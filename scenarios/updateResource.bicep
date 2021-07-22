// https://docs.microsoft.com/en-us/azure/architecture/guide/azure-resource-manager/advanced-templates/update-resource#example-template

resource VNet 'Microsoft.Network/virtualNetworks@2016-03-30' = {
  name: 'VNet'
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/22'
      ]
    }
    subnets: [
      {
        name: 'firstSubnet'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
    ]
  }
}
resource nic1 'Microsoft.Network/networkInterfaces@2015-06-15' = {
  name: 'nic1'
  location: resourceGroup().location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: '${VNet.id}/subnets/firstSubnet'
          }
        }
      }
    ]
  }
}
module updateVNet './nested_updateVNet.bicep' = {
  name: 'updateVNet'
  params: {
    virtualNetwork: VNet.properties
  }
  dependsOn: [
    nic1
  ]
}
