// ============================================================
// CCoE Landing Zone — Security Baseline (subscription scope)
//
// - Defender for Cloud plans (default + key workloads)
// - Deny non-HTTPS policy assignment (built-in, stable ID)
// - NCSC CSP baseline: deployed only when the policy set ID is
//   supplied, so first apply never fails on a missing definition.
//
// Tag enforcement lives in policies/bicep/ — do not duplicate it here.
// ============================================================

targetScope = 'subscription'

param prefix string = 'ccoe'
@description('Management group ID for the NCSC CSP baseline assignment')
param managementGroupId string = 'ccoe-landing-zone'
@description('Policy set definition ID for the NCSC CSP baseline (empty = skip)')
param ncscBaselinePolicySetId string = ''

resource defenderPlan 'Microsoft.Defender/plans@2024-01-01' = {
  name: 'current'
  scope: subscription()
  properties: {
    enableDefault: true
    pricingTiers: [
      { planName: 'Storage', enabled: true, pricingTier: 'Standard' }
      { planName: 'KeyVault', enabled: true, pricingTier: 'Standard' }
      { planName: 'AppServices', enabled: true, pricingTier: 'Standard' }
      { planName: 'Containers', enabled: true, pricingTier: 'Standard' }
      { planName: 'SqlServers', enabled: true, pricingTier: 'Standard' }
    ]
  }
}

// ------------------------------------------------------------
// Policy assignments (subscription scope)
// ------------------------------------------------------------
resource denyNonHttpsAssign 'Microsoft.Authorization/policyAssignments@2024-04-01' = {
  name: '${prefix}-deny-non-https'
  properties: {
    // Built-in: "Deny access to non-HTTPS endpoints" (stable GUID)
    policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/0a914e76-750f-4e1c-a0ec-39d1ed48ac28'
    scope: subscription().id
    displayName: 'CCoE — Deny non-HTTPS endpoints'
  }
}

// NCSC CSP baseline — only deployed when the ID is supplied.
resource ncscBaselineAssign 'Microsoft.Authorization/policyAssignments@2024-04-01' = [ if (ncscBaselinePolicySetId != ''): {
  name: '${prefix}-ncsc-csp-baseline'
  properties: {
    policyDefinitionId: ncscBaselinePolicySetId
    scope: '/providers/Microsoft.Management/managementGroups/${managementGroupId}'
    displayName: 'CCoE — NCSC CSP baseline'
  }
}]

// ------------------------------------------------------------
// Outputs
// ------------------------------------------------------------
output defenderPlanResourceId string = defenderPlan.id
output policyAssignmentNames array = [ denyNonHttpsAssign.name ]
