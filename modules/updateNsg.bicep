param nsg object
param nsgName string

resource vmNsg 'Microsoft.Network/networkSecurityGroups@2020-11-01' = {
  name: nsgName
  location: nsg.location
  properties: {
    securityRules: [
      {
        name: 'Allow_RemoteDesktop'
        properties: {
          description: 'Allow Remote Desktop Protocol port TCP/3389'
          direction: 'Inbound'
          priority: 100
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '3389'
          protocol: 'Tcp'
          access: 'Allow'
        }
      }
    ]
  }
}
