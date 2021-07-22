param nic object
param pipId string

resource vmNic 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: nic.name
  location: nic.location
  properties: {
    ipConfigurations: [
      {
        name: 'ipConfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: nic.properties.ipConfigurations[0].properties.subnet.id
          }
          publicIPAddress: {
            id: pipId
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: nic.properties.networkSecurityGroup.id
    }
  }
}
