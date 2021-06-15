targetScope = 'subscription'

param rgName string 

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: deployment().location
}

// First: Virtual Network
// ----------------------
module vnet '../../modules/VirtualNetwork.bicep' = {
  name: 'networkDeployment'
  scope: rg
  params: {
    name: 'VNet42'
  }
}

// Second: Virtual Machine(s)
// --------------------------
module vm1 '../../modules/WindowsVmPip.bicep' = {
  name: 'vm1Deployment'
  scope: rg
  params: {
    name: 'VM1'
    size: 'Standard_DS2_v2'
    subnetId: vnet.outputs.serverSubnetId
    dscScript: 'dscWindowsServer.ps1'
    dscFunction: 'popupTryWacOff'
    customScript: 'script1.ps1'
  }
}
