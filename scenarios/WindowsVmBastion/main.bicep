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
    name: 'VNet1'
  }
}

// Second: Virtual Machine(s)
// --------------------------
module vm1 '../../modules/WindowsVm.bicep' = {
  name: 'vm1Deployment'
  scope: rg
  params: {
    name: 'VM1'
    size: 'Standard_DS2_v2'
    subnetId: vnet.outputs.serverSubnetId
    dscScript:    'config32.ps1'
    customScript: 'script2.ps1'
  }
}
module vm2 '../../modules/WindowsVm.bicep' = {
  name: 'vm2Deployment'
  scope: rg
  params: {
    name: 'VM2'
    size: 'Standard_DS2_v2'
    subnetId: vnet.outputs.serverSubnetId
    dscScript:    'config32.ps1'
    customScript: 'script0_measured.ps1'
  }
}

// Third: Bastion Host
// -------------------
module bastion '../../modules/BastionHost.bicep' = {
  name: 'bastionDeployment'
  scope: rg
  params: {
    bastionName: 'Bastion'
    bastionSubnetId: vnet.outputs.bastionSubnetId
  }
}
