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
param customScript  string = 'script1.ps1'

var fileUri = 'https://raw.githubusercontent.com/www42/Bicep/master/scripts/${customScript}'
var command = 'powershell.exe -ExecutionPolicy Unrestricted -File ${customScript}'

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
resource vmCustomScript 'Microsoft.Compute/virtualMachines/extensions@2021-03-01' = {
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
        fileUri
      ]
    commandToExecute: command
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
        }
      }
    ]
    networkSecurityGroup: {
      id: vmNsg.id
    }
  }
}
resource vmNsg 'Microsoft.Network/networkSecurityGroups@2020-11-01' = {
  name: '${name}-NSG'
  location: location
  properties: {
    securityRules: [
    ]
  }
}

output vmId string = vm.id