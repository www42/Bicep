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
    dscScript:    'config42.ps1'
    customScript: 'script4.ps1'
  }
}

// Create Public IP
module vm1Pip '../../templates/publicIp.bicep' = {
  name: 'vm1PipDeployment-${datestring}'
  scope: rg
  params: {
    name: 'VM1-Pip'
  }
}

// Update VM Nic
module updateVm1Nic '../../templates/update_Nic.bicep' = {
  name: 'updateVm1Nic-${datestring}'
  scope: rg
  params: {
    nic: vm1.outputs.vmNic
    nicName: vm1.outputs.vmNicName
    pipId: vm1Pip.outputs.pipId
  }
}

// Update VM NSG
module updateVm1Nsg '../../templates/update_Nsg.bicep' = {
  name: 'updateVm1Nsg-${datestring}'
  scope: rg
  params: {
    nsg: vm1.outputs.vmNsg
    nsgName: vm1.outputs.vmNsgName
  }  
}
