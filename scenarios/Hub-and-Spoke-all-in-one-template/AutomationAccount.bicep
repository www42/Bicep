// Automation account
param aaName string
param deployAaJob bool = true

// PowerShell modules
param aaModuleName string = 'ActiveDirectoryDsc'
param aaModuleContentLink string = 'https://psg-prod-eastus.azureedge.net/packages/activedirectorydsc.6.0.1.nupkg'

// DSC configurations
param aaConfigurationName string = 'ADDomain_NewForest'
param aaConfigurationSourceUri string = 'https://raw.githubusercontent.com/www42/arm/master/DSC/ADDomain_NewForest.ps1'

// Location
param location string = resourceGroup().location

var aaJobName = '${aaConfigurationName}-Compile'

resource aa 'Microsoft.Automation/automationAccounts@2020-01-13-preview' = {
  name: aaName
  location: location
  properties: {
    sku: {
      name: 'Free'
    }
  }
}
resource aaModule 'Microsoft.Automation/automationAccounts/modules@2020-01-13-preview' = {
  name: '${aa.name}/${aaModuleName}'
  properties: {
    contentLink: {
      uri: aaModuleContentLink
    }
  }
}
resource aaConfiguration 'Microsoft.Automation/automationAccounts/configurations@2019-06-01' = {
  name: '${aa.name}/${aaConfigurationName}'
  location: location
  properties: {
    source: {
      type: 'uri'
      value: aaConfigurationSourceUri
    }
    logProgress: true
    logVerbose: true
  }
}

// Bug: Automation account jobs are not idempotent
// https://feedback.azure.com/forums/246290-automation/suggestions/33065122-redeploying-jobschedule-resource-from-arm-template
resource aaJob 'Microsoft.Automation/automationAccounts/compilationjobs@2020-01-13-preview' = if (deployAaJob) {
  name: '${aa.name}/${aaJobName}'
  dependsOn: [
    aaModule
    aaConfiguration
  ]
  properties: {
    configuration: {
      name: aaConfigurationName
    }
    parameters: {
      DomainName: 'adatum.com'
      DomainAdminName: 'Student'
      DomainAdminPassword: 'Pa55w.rd1234'      
    }
  }
}
output automationAccountId string = aa.id
