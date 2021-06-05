// Virtual Network
param location string = resourceGroup().location

param name                       string  = 'VNet'
param addressSpace               array   = [
                                            '172.16.0.0/16'
                                           ]
// subnet[0] Server
param serverSubnetName            string = 'ServerSubnet'
param serverSubnetAddressPrefix   string = '172.16.0.0/24'
// subnet[1] Database
param databaseSubnetName          string = 'DatabaseSubnet'
param databaseSubnetAddressPrefix string = '172.16.1.0/24'
// subnet[2] Gateway
param gatewaySubnetName           string = 'GatewaySubnet'        // Do not change!
param gatewaySubnetAddressPrefix  string = '172.16.255.0/27'
// subnet[3] AzureBastion
param bastionSubnetName           string = 'AzureBastionSubnet'   // Do not change!
param bastionSubnetAddressPrefix  string = '172.16.255.32/27'
// subnet[4] AzureFirewall
param firewallSubnetName          string = 'AzureFirewallSubnet' // Do not change!
param firewallSubnetAddressPrefix string = '172.16.255.64/26'


resource vnet 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: addressSpace
    }
    subnets: [
      {
        name: serverSubnetName
        properties: {
          addressPrefix: serverSubnetAddressPrefix
        }
      }
      {
        name: databaseSubnetName
        properties: {
          addressPrefix: databaseSubnetAddressPrefix
        }
      }
      {
        name: gatewaySubnetName
        properties: {
          addressPrefix: gatewaySubnetAddressPrefix
        }
      }
      {
        name: bastionSubnetName
        properties: {
          addressPrefix: bastionSubnetAddressPrefix
        }
      }
      {
        name: firewallSubnetName
        properties: {
          addressPrefix: firewallSubnetAddressPrefix
        }
      }
    ]
  }
}

output serverSubnetId   string = vnet.properties.subnets[0].id 
output databaseSubnetId string = vnet.properties.subnets[1].id
output gatewaySubnetId  string = vnet.properties.subnets[2].id
output bastionSubnetId  string = vnet.properties.subnets[3].id
output firewallSubnetId string = vnet.properties.subnets[4].id
