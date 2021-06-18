## How to use the DSC extension for Azure virtual machines

<img src="../img/extension-logo.png" alt="DSC extension logo" width="80"/>


| File                            | What's inside?                                   |
| --------------------------------| ------------------------------------------------ |
| THE_WORLDS_BEST_DSC_CONFIGS.ps1 | The World's best DSC configurations (What else?) |
| config42.ps1                    | One single DSC configuration                     |
| allConfigs.zip                  | config`??`.ps1                                   |
| createZip.sh                    | Helper script to create the zip                  |


In Bicep create a resource in this way:

```
resource vmDsc 'Microsoft.Compute/virtualMachines/extensions@2021-03-01' = {
  name: 'dsc'
  parent: vm
  location: location
  properties: {
    publisher: 'Microsoft.Powershell'
    type: 'DSC'
    typeHandlerVersion: '2.83'
    autoUpgradeMinorVersion: true
    settings: {
      configuration: {
        url:      'https://github.com/.../allConfigs.zip'
        script:   'config42.ps1'
        function: 'config42'
      }
    }
  }
}
```

You can use only one DSC configuration (`function: 'config42'`) per VM.

[Azure Automation Account](https://docs.microsoft.com/en-us/azure/automation/automation-dsc-overview) is another way to apply DSC configurations to virtual machines. 