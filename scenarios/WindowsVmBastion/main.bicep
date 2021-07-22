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
    customScript: 'script0.ps1'
  }
}

// Create Public IP
module vm1Pip '../../modules/publicIp.bicep' = {
  name: 'vm1PipDeployment'
  scope: rg
  params: {
    name: 'VM1-Pip'
  }
}

// Update VM Nic
module updateVm1Nic '../../modules/updateNic.bicep' = {
  name: 'updateVm1Nic'
  scope: rg
  params: {
    nic: vm1.outputs.vmNic
    pipId: vm1Pip.outputs.pipId
  }
}

// Third: Bastion Host
// -------------------
// module bastion '../../modules/BastionHost.bicep' = {
  // name: 'bastionDeployment'
  // scope: rg
  // params: {
    // bastionName: 'Bastion'
    // bastionSubnetId: vnet.outputs.bastionSubnetId
  // }
// }
