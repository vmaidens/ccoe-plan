// ============================================================
// CCoE Landing Zone — top-level deployment
// Phase 1 of the CCoE Delivery Action Plan (Weeks 2-6)
//
// Deploys:
//   - Hub-spoke networking in UK South (Bastion, NSGs, UDRs, peering)
//   - Security baseline at subscription scope (Defender + policy assignments)
//   - Cost governance at subscription scope (budgets + tag policies)
//
// Deploy:
//   az deployment sub create \
//     --location uksouth \
//     --template-file main.bicep \
//     --parameters prefix=ccoe managementGroupId=<mg-id> adminGroupObjectId=<guid>
// ============================================================

targetScope = 'subscription'

param prefix string = 'ccoe'
@description('Primary region (restricted by policy to uksouth/ukwest)')
param location string = 'uksouth'
@description('DR region')
param drLocation string = 'ukwest'
@description('Management group ID for policy assignments (see policies/bicep/)')
param managementGroupId string = 'ccoe-landing-zone'
@description('Object ID of the Entra group that receives CCoE Platform Admin role')
param adminGroupObjectId string

// ------------------------------------------------------------
// Resource groups
// ------------------------------------------------------------
resource rgLz 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: '${prefix}-lz-${location}'
  location: location
}

resource rgDr 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: '${prefix}-lz-${drLocation}'
  location: drLocation
}

// ------------------------------------------------------------
// Networking (hub-spoke, primary region)
// ------------------------------------------------------------
module networking './modules/networking.bicep' = {
  name: 'ccoe-networking'
  scope: rgLz
  params: {
    prefix: prefix
    location: location
  }
}

// ------------------------------------------------------------
// Security baseline (subscription scope)
// ------------------------------------------------------------
module security './modules/security.bicep' = {
  name: 'ccoe-security-baseline'
  scope: subscription()
  params: {
    managementGroupId: managementGroupId
  }
}

// ------------------------------------------------------------
// Cost governance (subscription scope)
// ------------------------------------------------------------
module cost './modules/cost.bicep' = {
  name: 'ccoe-cost-governance'
  scope: subscription()
  params: {
    prefix: prefix
    monthlyBudgetUsd: 50000
  }
}

// ------------------------------------------------------------
// Outputs (record these in the delivery log)
// ------------------------------------------------------------
output hubVnetId string = networking.outputs.hubVnetId
output bastionSubnetName string = networking.outputs.bastionSubnetName
output spokeVnetIds object = networking.outputs.spokeVnetIds
output defenderPlanResourceId string = security.outputs.defenderPlanResourceId
