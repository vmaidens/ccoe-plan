// Bicep Policy Definitions for CCoE Quick-Deploy (Continued)
// Policies 4-10
// Generated: 2026-08-15
// Author: Vince Maidens

// ============================================================
// Policy 4: Require NSGs on all subnets
// Enforces network segmentation
// ============================================================
targetScope = 'managementGroup'

param managementGroupId string = 'ccoe-landing-zone'
param nsgPolicyName string = 'require-nsgs-on-subnets'
param nsgPolicyDefId string = '/providers/Microsoft.Authorization/policyDefinitions/06a78e20-9358-41c9-9692-5299592f15be'

resource nsgAssign 'Microsoft.Authorization/policyAssignments@2023-04-01' = {
  name: nsgPolicyName
  properties: {
    policyDefinitionId: nsgPolicyDefId
    scope: managementGroupId
    displayName: 'Require NSGs on All Subnets'
    description: 'Enforces Network Security Groups on all subnets for network segmentation'
  }
}

// ============================================================
// Policy 5: Disable public endpoints for storage accounts
// Data protection - no public blob/file access
// ============================================================
param storageNoPublicPolicyName string = 'disable-public-endpoints-storage'
param storageNoPublicPolicyDefId string = '/providers/Microsoft.Authorization/policyDefinitions/55f3eceb-557b-4d52-b493-139ee7ba32c1'

resource storageNoPublicAssign 'Microsoft.Authorization/policyAssignments@2023-04-01' = {
  name: storageNoPublicPolicyName
  properties: {
    policyDefinitionId: storageNoPublicPolicyDefId
    scope: managementGroupId
    displayName: 'Disable Public Endpoints for Storage Accounts'
    description: 'Prevents storage accounts from having public blob or file endpoints'
  }
}

// ============================================================
// Policy 6: Require encryption at rest
// All storage, databases, disks must be encrypted
// ============================================================
param encryptionPolicyName string = 'require-encryption-at-rest'
param encryptionPolicyDefId string = '/providers/Microsoft.Authorization/policyDefinitions/11d6b855-d0f2-4f9b-b981-550c0ebfc565'

resource encryptionAssign 'Microsoft.Authorization/policyAssignments@2023-04-01' = {
  name: encryptionPolicyName
  properties: {
    policyDefinitionId: encryptionPolicyDefId
    scope: managementGroupId
    displayName: 'Require Encryption at Rest'
    description: 'Requires encryption at rest for all storage accounts, databases, and managed disks'
  }
}

// ============================================================
// Policy 7: Restrict inbound IPs for SSH/RDP
// Only jump boxes allowed
// ============================================================
param sshRdpPolicyName string = 'restrict-ssh-rdp-access'
param sshRdpPolicyDefId string = '/providers/Microsoft.Authorization/policyDefinitions/3447016f-a614-4939-8064-03f00ff0c78f'

resource sshRdpAssign 'Microsoft.Authorization/policyAssignments@2023-04-01' = {
  name: sshRdpPolicyName
  properties: {
    policyDefinitionId: sshRdpPolicyDefId
    scope: managementGroupId
    displayName: 'Restrict SSH/RDP Inbound Access'
    description: 'Restricts SSH/RDP inbound access to jump boxes only'
  }
}

// ============================================================
// Policy 8: Enable Defender for Cloud
// Workload protection across all subscriptions
// ============================================================
param defenderPolicyName string = 'enable-defender-for-cloud'
param defenderPolicyDefId string = '/providers/Microsoft.Authorization/policyDefinitions/1f551d20-613b-4661-8898-84e084b5706c'

resource defenderAssign 'Microsoft.Authorization/policyAssignments@2023-04-01' = {
  name: defenderPolicyName
  properties: {
    policyDefinitionId: defenderPolicyDefId
    scope: managementGroupId
    displayName: 'Enable Defender for Cloud'
    description: 'Enables Microsoft Defender for Cloud workload protection across all subscriptions'
  }
}

// ============================================================
// Policy 9: Require private endpoints for PaaS
// Network isolation for PaaS services
// ============================================================
param privateEndpointPolicyName string = 'require-private-endpoints'
param privateEndpointPolicyDefId string = '/providers/Microsoft.Authorization/policyDefinitions/0a15ec92-a926-4a98-b2ee-10034a1f3a50'

resource privateEndpointAssign 'Microsoft.Authorization/policyAssignments@2023-04-01' = {
  name: privateEndpointPolicyName
  properties: {
    policyDefinitionId: privateEndpointPolicyDefId
    scope: managementGroupId
    displayName: 'Require Private Endpoints for PaaS'
    description: 'Requires private endpoints for PaaS services for network isolation'
  }
}

// ============================================================
// Policy 10: Deny resource deletion without approval
// Change control for production resources
// ============================================================
param denyDeletePolicyName string = 'deny-resource-deletion'
param denyDeletePolicyDefId string = '/providers/Microsoft.Authorization/policyDefinitions/404c3081-a854-4457-ae30-d263b0510fb9'

resource denyDeleteAssign 'Microsoft.Authorization/policyAssignments@2023-04-01' = {
  name: denyDeletePolicyName
  properties: {
    policyDefinitionId: denyDeletePolicyDefId
    scope: managementGroupId
    displayName: 'Deny Resource Deletion Without Approval'
    description: 'Denies resource deletion without proper change control approval'
  }
}
