## How to use the DSC extension for Azure virtual machines

<img src="../img/extension-logo.png" alt="DSC extension logo" width="80"/>


| What's this?           |                   |
| -----------------------| ----------------- |
| `configuration foo {}` | DSC configuration written in PowerShell code   |
| foo.ps1                | File containing one or more DSC configurations |
| foo.zip                | Zip file containing one or more .ps1 files     |
| foo.mof                | Compiled configuration<br />(Compilation is done by the extension handler automatically.) |

In Bicep template create a resource specify these values accordingly

```
resource vmDsc 'Microsoft.Compute/virtualMachines/extensions@2021-03-01' = {
...  
    settings: {
        configuration: {
            url:      'https://github.com/.../foo.zip'
            script:   'foo.ps1'
            function: 'foo'
        }
    }
```

You can use only one DSC configuration (`function: 'foo'`) per VM.

[Azure Automation Account](https://docs.microsoft.com/en-us/azure/automation/automation-dsc-overview) is another way to apply DSC configurations to virtual machines. 