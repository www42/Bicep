// Virtual Machine, no public IP, NSG with default rules only
param location string = resourceGroup().location

param name          string = 'VM'
param size          string = 'Standard_DS2_v2'
param adminUserName string = 'Student'
param adminPassword string = 'Pa55w.rd1234'
param subnetId      string
param dscUrl        string = 'https://github.com/www42/Bicep/raw/master/dsc/allConfigs.zip'
param dscScript     string = 'config32.ps1'
param customScript  string = 'script0.ps1'

var fileUri = 'https://raw.githubusercontent.com/www42/Bicep/master/scripts/${customScript}'
var command = 'powershell.exe -ExecutionPolicy Unrestricted -File ${customScript}'
var dscFunction = split(dscScript,'.')[0]

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
resource vmCustomScript 'Microsoft.Compute/virtualMachines/extensions@2021-03-01' = {
  name: 'customScript'
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
resource vmDsc 'Microsoft.Compute/virtualMachines/extensions@2021-03-01' = {
  name: 'dsc'
  parent: vm
  dependsOn: [
    vmCustomScript
  ]
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

output vmId string = vm.id
output vmNic object = vmNic
output vmNicName string = vmNic.name
output vmNsg object = vmNsg
output vmNsgName string = vmNsg.name
