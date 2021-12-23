targetScope = 'subscription'

param rgName string 

resource rg 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: rgName
  location: deployment().location
}

// First: Automation Account
module automationDeploy 'AutomationAccount.bicep' = {
  name: 'automationDeploy'
  scope: rg
  params: {
    aaName: 'Adatum-Automation'
    
    // Attention! Automation account jobs are not idempotent! This means 
    //    deployAaJob: true     only for the first time, in later deployment set to 'false'
    deployAaJob: true
  }
}

// Next: Hub and Spoke 
module hubAndSpokeDeploy 'HubAndSpoke.bicep' = {
  name: 'hubAndSpokeDeploy'
  scope: rg
  params: {
    aaId:             automationDeploy.outputs.automationAccountId
    aaConfiguration: 'ADDomain_NewForest.localhost' 
  }
}

// TO DO
// -------
//  NVA: Nic enable IP forwarding
//  NVA: Configure and start Service 'Routing and RAS'
//  Windows Firewall:
//      NVA: FW ist enabled (Private profile). Servermanager behauptet: FW ist off, stimmt aber nicht. Keine Regel für ICMP, d.h. kann nicht angepingt werden.
//      DC1: FW ist enabled (Private profile). Es gibt eine Regel für ICMP (über Domain Controller). D.h. kann angepingt werden.
//  Table1: do not associate with any sbnet
