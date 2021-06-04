param location string = resourceGroup().location

param vnetName                       string = 'VNet'
param vnetAddressSpace               array  = [
                                               '172.16.0.0/16'
                                              ]
// subnet[0] Server
param vnetServerSubnetName            string = 'ServerSubnet'
param vnetServerSubnetAddressPrefix   string = '172.16.0.0/24'
// subnet[1] Database
param vnetDatabaseSubnetName          string = 'DatabaseSubnet'
param vnetDatabaseSubnetAddressPrefix string = '172.16.1.0/24'
// subnet[2] Gateway
param vnetGatewaySubnetName           string = 'GatewaySubnet'        // Do not change!
param vnetGatewaySubnetAddressPrefix  string = '172.16.255.0/27'
// subnet[3] AzureBastion
param vnetBastionSubnetName           string = 'AzureBastionSubnet'   // Do not change!
param vnetBastionSubnetAddressPrefix  string = '172.16.255.32/27'
// subnet[4] AzureFirewall
param vnetFirewallSubnetName          string = 'AzureFirewallSubnet' // Do not change!
param vnetFirewallSubnetAddressPrefix string = '172.16.255.64/26'


resource vnet 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: vnetAddressSpace
    }
    subnets: [
      {
        name: vnetServerSubnetName
        properties: {
          addressPrefix: vnetServerSubnetAddressPrefix
        }
      }
      {
        name: vnetDatabaseSubnetName
        properties: {
          addressPrefix: vnetDatabaseSubnetAddressPrefix
        }
      }
      {
        name: vnetGatewaySubnetName
        properties: {
          addressPrefix: vnetGatewaySubnetAddressPrefix
        }
      }
      {
        name: vnetBastionSubnetName
        properties: {
          addressPrefix: vnetBastionSubnetAddressPrefix
        }
      }
      {
        name: vnetFirewallSubnetName
        properties: {
          addressPrefix: vnetFirewallSubnetAddressPrefix
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
