// Virtual Machine
param location string = resourceGroup().location

param name          string = 'VM'
param size          string = 'Standard_DS2_v2'
param adminUserName string = 'Student'
param adminPassword string = 'Pa55w.rd1234'
param subnetId      string
param dscUrl        string = 'https://github.com/www42/Bicep/raw/master/dsc/dscWindowsServer.zip'
param dscScript     string = 'dscWindowsServer.ps1'
param dscFunction   string = 'ieSecurityOff'

resource vm 'Microsoft.Compute/virtualMachines@2020-12-01' = {
  name: name
  location: location
  properties: {
    hardwareProfile: {
      vmSize: size
    }
    storageProfile: {
      imageReference:{
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
      osDisk: {
        name: '${name}-Disk'
        caching: 'ReadWrite'
        createOption: 'FromImage'
      }
    }
    osProfile: {
      computerName: name
      adminUsername: adminUserName
      adminPassword: adminPassword
    }
    networkProfile:{
      networkInterfaces: [
        {
          id: vmNic.id
        }
      ]
    }
  }
}
resource vmDsc 'Microsoft.Compute/virtualMachines/extensions@2021-03-01' = {
  name: 'WindowsServerSettings'
  parent: vm
  location: location
  properties: {
    publisher: 'Microsoft.Powershell'
    type: 'DSC'
    typeHandlerVersion: '2.83'
    autoUpgradeMinorVersion: true
    settings: {
      configuration: {
        url: dscUrl
        script: dscScript
        function: dscFunction
      }
    }
  }
}
resource vmScript 'Microsoft.Compute/virtualMachines/extensions@2021-03-01' = {
  name: 'WindowsServerScript'
  parent: vm
  location: location
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.10'
    autoUpgradeMinorVersion: true
    settings: {
      fileUris: [
        'https://github.com/www42/Bicep/raw/customscript/scripts/script.ps1'
      ]
    commandToExecute: 'powershell.exe -ExecutionPolicy Unrestricted -File script1.ps1'
    }
  }
}
resource vmNic 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: '${name}-Nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipConfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: subnetId
          }
          publicIPAddress: {
            id: vmPip.id
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: vmNsg.id
    }
  }
}
resource vmPip 'Microsoft.Network/publicIPAddresses@2020-11-01' = {
  name: '${name}-Pip'
  location: location
  sku: {
    name: 'Basic'
    tier: 'Regional'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Dynamic'
  }
}
resource vmNsg 'Microsoft.Network/networkSecurityGroups@2020-11-01' = {
  name: '${name}-NSG'
  location: location
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

output vmId string = vm.id
