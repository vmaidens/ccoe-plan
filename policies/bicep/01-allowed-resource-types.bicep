// Bicep Policy Definitions for CCoE Quick-Deploy
// Generated: 2026-08-15
// Author: Vince Maidens
// Reference: CCoE Build Plan Appendix C

// ============================================================
// Policy 1: Allowed resource types
// Restricts deployments to approved Azure services
// ============================================================
targetScope = 'managementGroup'

param managementGroupId string = 'ccoe-landing-zone'
param policyAssignName string = 'allowed-resource-types'
param policyDefId string = '/providers/Microsoft.Authorization/policyDefinitions/1f313768-c9ae-4cfd-8417-bf576cda4e2e'

resource policyAssign 'Microsoft.Authorization/policyAssignments@2023-04-01' = {
  name: policyAssignName
  properties: {
    policyDefinitionId: policyDefId
    scope: managementGroupId
    parameters: {
      list: {
        value: [
          'Microsoft.Web/sites'
          'Microsoft.Web/serverfarms'
          'Microsoft.Sql/servers'
          'Microsoft.Sql/servers/databases'
          'Microsoft.Storage/storageAccounts'
          'Microsoft.Network/virtualNetworks'
          'Microsoft.Network/virtualNetworks/subnets'
          'Microsoft.Network/networkSecurityGroups'
          'Microsoft.Network/publicIPAddresses'
          'Microsoft.Network/loadBalancers'
          'Microsoft.Network/azureFirewalls'
          'Microsoft.Network/dnszones'
          'Microsoft.KeyVault/vaults'
          'Microsoft.KeyVault/vaults/secrets'
          'Microsoft.KeyVault/vaults/accessPolicies'
          'Microsoft.ContainerService/managedClusters'
          'Microsoft.ContainerService/managedClusters/agentPools'
          'Microsoft.ContainerRegistry/registries'
          'Microsoft.Insights/components'
          'Microsoft.OperationalInsights/workspaces'
          'Microsoft.Compute/virtualMachines'
          'Microsoft.Compute/disks'
          'Microsoft.Compute/virtualMachineScaleSets'
          'Microsoft.DataFactory/factories'
          'Microsoft.DataFactory/factories/pipelines'
          'Microsoft.Databricks/workspaces'
          'Microsoft.EventGrid/topics'
          'Microsoft.EventGrid/topics/topics'
          'Microsoft.EventHub/namespaces'
          'Microsoft.ServiceBus/namespaces'
          'Microsoft.CognitiveServices/accounts'
          'Microsoft.MachineLearningServices/workspaces'
          'Microsoft.Authorization/roleDefinitions'
          'Microsoft.Authorization/policyDefinitions'
          'Microsoft.Authorization/policyAssignments'
          'Microsoft.Authorization/policySetDefinitions'
          'Microsoft.Resources/deploymentScripts'
          'Microsoft.Resources/resourceGroups'
          'Microsoft.Resources/subscriptions'
          'Microsoft.ManagedIdentity/userAssignedIdentities'
          'Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials'
        ]
      }
    }
    displayName: 'Allowed Resource Types'
    description: 'Restricts resource deployments to approved Azure services only'
  }
}

// ============================================================
// Policy 2: Require tags
// Enforces costCentre, environment, project, dataClassification tags
// ============================================================
param requireTagsName string = 'require-tags'
param requireTagsDefId string = '/providers/Microsoft.Authorization/policyDefinitions/1e390493-1089-467a-b30a-e3cc0a514c2d'

resource requireTagsAssign 'Microsoft.Authorization/policyAssignments@2023-04-01' = {
  name: requireTagsName
  properties: {
    policyDefinitionId: requireTagsDefId
    scope: managementGroupId
    parameters: {
      tagName: {
        value: 'costCentre'
      }
      tagValues: {
        value: ['*']
      }
    }
    displayName: 'Require Tags'
    description: 'Requires costCentre, environment, project, and dataClassification tags on all resources'
  }
}

// ============================================================
// Policy 3: Restrict locations
// Limits deployments to UK South (and DR region)
// ============================================================
param restrictLocationsName string = 'restrict-locations'
param restrictLocationsDefId string = '/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49ec-bc68-c89d08e21e36'

resource restrictLocationsAssign 'Microsoft.Authorization/policyAssignments@2023-04-01' = {
  name: restrictLocationsName
  properties: {
    policyDefinitionId: restrictLocationsDefId
    scope: managementGroupId
    parameters: {
      list: {
        value: [
          'uksouth'
          'ukwest'
        ]
      }
    }
    displayName: 'Restrict Locations'
    description: 'Restricts resource deployments to UK South (primary) and UK West (DR) only'
  }
}
