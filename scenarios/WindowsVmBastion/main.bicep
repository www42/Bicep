targetScope = 'subscription'

param rgName string
param datestring string

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: deployment().location
}

// First: Virtual Network
// ----------------------
module vnet '../../templates/virtualNetwork.bicep' = {
  name: 'networkDeployment-${datestring}'
  scope: rg
  params: {
    name: 'VNet1'
  }
}

// Second: Virtual Machine(s)
// --------------------------
module vm1 '../../templates/windowsVm.bicep' = {
  name: 'vm1Deployment-${datestring}'
  scope: rg
  params: {
    name: 'VM1'
    size: 'Standard_DS2_v2'
    subnetId: vnet.outputs.serverSubnetId
    dscScript:    'config32.ps1'
    customScript: 'script32.ps1'
  }
}

// Third: Bastion Host
// -------------------
module bastion '../../templates/bastionHost.bicep' = {
  name: 'bastionDeployment-${datestring}'
  scope: rg
  params: {
    bastionName: 'Bastion'
    bastionSubnetId: vnet.outputs.bastionSubnetId
  }
}
