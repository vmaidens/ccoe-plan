# CCoE Terraform Policy Definitions
# Generated: 2026-08-15
# Author: Vince Maidens
# Reference: CCoE Build Plan Appendix C
#
# Usage: terraform init && terraform plan -var="management_group_id=ccoe-landing-zone" && terraform apply

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0"
    }
  }
}

variable "management_group_id" {
  description = "The management group ID to assign policies to"
  type        = string
  default     = "ccoe-landing-zone"
}

variable "location" {
  description = "Default location for resources (restricted to UK South/UK West)"
  type        = string
  default     = "uksouth"
}

# ============================================================
# Policy 1: Allowed resource types
# ============================================================
resource "azurerm_policy_definition" "allowed_resource_types" {
  name                 = "allowed-resource-types"
  policy_type          = "Custom"
  mode                 = "All"
  display_name       = "Allowed Resource Types"
  description        = "Restricts resource deployments to approved Azure services only"

  policy_rule = jsonencode({
    if = {
      anyOf = [
        {
          field  = "type"
          notIn  = [
            "Microsoft.Web/sites",
            "Microsoft.Web/serverfarms",
            "Microsoft.Sql/servers",
            "Microsoft.Sql/servers/databases",
            "Microsoft.Storage/storageAccounts",
            "Microsoft.Network/virtualNetworks",
            "Microsoft.Network/virtualNetworks/subnets",
            "Microsoft.Network/networkSecurityGroups",
            "Microsoft.Network/publicIPAddresses",
            "Microsoft.Network/loadBalancers",
            "Microsoft.Network/azureFirewalls",
            "Microsoft.Network/dnszones",
            "Microsoft.KeyVault/vaults",
            "Microsoft.KeyVault/vaults/secrets",
            "Microsoft.KeyVault/vaults/accessPolicies",
            "Microsoft.ContainerService/managedClusters",
            "Microsoft.ContainerService/managedClusters/agentPools",
            "Microsoft.ContainerRegistry/registries",
            "Microsoft.Insights/components",
            "Microsoft.OperationalInsights/workspaces",
            "Microsoft.Compute/virtualMachines",
            "Microsoft.Compute/disks",
            "Microsoft.Compute/virtualMachineScaleSets",
            "Microsoft.DataFactory/factories",
            "Microsoft.DataFactory/factories/pipelines",
            "Microsoft.Databricks/workspaces",
            "Microsoft.EventGrid/topics",
            "Microsoft.EventHub/namespaces",
            "Microsoft.ServiceBus/namespaces",
            "Microsoft.CognitiveServices/accounts",
            "Microsoft.MachineLearningServices/workspaces",
            "Microsoft.ManagedIdentity/userAssignedIdentities",
            "Microsoft.Resources/resourceGroups",
            "Microsoft.Authorization/roleDefinitions",
            "Microsoft.Authorization/policyDefinitions",
            "Microsoft.Authorization/policyAssignments",
            "Microsoft.Authorization/policySetDefinitions",
            "Microsoft.Resources/deploymentScripts",
            "Microsoft.Resources/subscriptions"
          ]
        }
      ]
    }
    then = {
      effect = "deny"
    }
  })
}

resource "azurerm_policy_assignment" "allowed_resource_types" {
  name                 = "allowed-resource-types"
  policy_definition_id = azurerm_policy_definition.allowed_resource_types.id
  scope                = data.azurerm_management_group.ccoe.id
  display_name       = "Allowed Resource Types"
  description        = "Restricts resource deployments to approved Azure services only"

  parameters = jsonencode({
    list = {
      value = [
        "Microsoft.Web/sites",
        "Microsoft.Web/serverfarms",
        "Microsoft.Sql/servers",
        "Microsoft.Sql/servers/databases",
        "Microsoft.Storage/storageAccounts",
        "Microsoft.Network/virtualNetworks",
        "Microsoft.Network/virtualNetworks/subnets",
        "Microsoft.Network/networkSecurityGroups",
        "Microsoft.Network/publicIPAddresses",
        "Microsoft.Network/loadBalancers",
        "Microsoft.Network/azureFirewalls",
        "Microsoft.Network/dnszones",
        "Microsoft.KeyVault/vaults",
        "Microsoft.KeyVault/vaults/secrets",
        "Microsoft.KeyVault/vaults/accessPolicies",
        "Microsoft.ContainerService/managedClusters",
        "Microsoft.ContainerService/managedClusters/agentPools",
        "Microsoft.ContainerRegistry/registries",
        "Microsoft.Insights/components",
        "Microsoft.OperationalInsights/workspaces",
        "Microsoft.Compute/virtualMachines",
        "Microsoft.Compute/disks",
        "Microsoft.Compute/virtualMachineScaleSets",
        "Microsoft.DataFactory/factories",
        "Microsoft.DataFactory/factories/pipelines",
        "Microsoft.Databricks/workspaces",
        "Microsoft.EventGrid/topics",
        "Microsoft.EventHub/namespaces",
        "Microsoft.ServiceBus/namespaces",
        "Microsoft.CognitiveServices/accounts",
        "Microsoft.MachineLearningServices/workspaces",
        "Microsoft.ManagedIdentity/userAssignedIdentities",
        "Microsoft.Resources/resourceGroups",
        "Microsoft.Authorization/roleDefinitions",
        "Microsoft.Authorization/policyDefinitions",
        "Microsoft.Authorization/policyAssignments",
        "Microsoft.Authorization/policySetDefinitions",
        "Microsoft.Resources/deploymentScripts",
        "Microsoft.Resources/subscriptions"
      ]
    }
  })
}

# ============================================================
# Policy 2: Require tags
# ============================================================
resource "azurerm_policy_definition" "require_tags" {
  name                 = "require-tags"
  policy_type          = "Custom"
  mode                 = "All"
  display_name       = "Require Tags"
  description        = "Requires costCentre, environment, project, and dataClassification tags on all resources"

  policy_rule = jsonencode({
    if = {
      anyOf = [
        {
          field  = "tags['costCentre']"
          exists = false
        },
        {
          field  = "tags['environment']"
          exists = false
        },
        {
          field  = "tags['project']"
          exists = false
        },
        {
          field  = "tags['dataClassification']"
          exists = false
        }
      ]
    }
    then = {
      effect = "deny"
    }
  })
}

resource "azurerm_policy_assignment" "require_tags" {
  name                 = "require-tags"
  policy_definition_id = azurerm_policy_definition.require_tags.id
  scope                = data.azurerm_management_group.ccoe.id
  display_name       = "Require Tags"
  description        = "Requires costCentre, environment, project, and dataClassification tags on all resources"
}

# ============================================================
# Policy 3: Restrict locations
# ============================================================
resource "azurerm_policy_definition" "restrict_locations" {
  name                 = "restrict-locations"
  policy_type          = "Custom"
  mode                 = "All"
  display_name       = "Restrict Locations"
  description        = "Restricts resource deployments to UK South (primary) and UK West (DR) only"

  policy_rule = jsonencode({
    if = {
      anyOf = [
        {
          field  = "location"
          notIn  = ["uksouth", "ukwest"]
        },
        {
          allOf = [
            {
              field  = "location"
              notIn  = ["uksouth", "ukwest"]
            }
          ]
        }
      ]
    }
    then = {
      effect = "deny"
    }
  })
}

resource "azurerm_policy_assignment" "restrict_locations" {
  name                 = "restrict-locations"
  policy_definition_id = azurerm_policy_definition.restrict_locations.id
  scope                = data.azurerm_management_group.ccoe.id
  display_name       = "Restrict Locations"
  description        = "Restricts resource deployments to UK South (primary) and UK West (DR) only"
}

# ============================================================
# Policy 4: Require NSGs on all subnets
# ============================================================
resource "azurerm_policy_definition" "require_nsgs" {
  name                 = "require-nsgs-on-subnets"
  policy_type          = "Custom"
  mode                 = "All"
  display_name       = "Require NSGs on All Subnets"
  description        = "Enforces Network Security Groups on all subnets for network segmentation"

  policy_rule = jsonencode({
    if = {
      allOf = [
        {
          field  = "type"
          equals = "Microsoft.Network/virtualNetworks/subnets"
        },
        {
          field  = "Microsoft.Network/virtualNetworks/subnets/networkSecurityGroup.id"
          exists = false
        }
      ]
    }
    then = {
      effect = "deny"
    }
  })
}

resource "azurerm_policy_assignment" "require_nsgs" {
  name                 = "require-nsgs-on-subnets"
  policy_definition_id = azurerm_policy_definition.require_nsgs.id
  scope                = data.azurerm_management_group.ccoe.id
  display_name       = "Require NSGs on All Subnets"
  description        = "Enforces Network Security Groups on all subnets for network segmentation"
}

# ============================================================
# Policy 5: Disable public endpoints for storage accounts
# ============================================================
resource "azurerm_policy_definition" "storage_no_public" {
  name                 = "disable-public-endpoints-storage"
  policy_type          = "Custom"
  mode                 = "All"
  display_name       = "Disable Public Endpoints for Storage Accounts"
  description        = "Prevents storage accounts from having public blob or file endpoints"

  policy_rule = jsonencode({
    if = {
      allOf = [
        {
          field  = "type"
          equals = "Microsoft.Storage/storageAccounts"
        },
        {
          anyOf = [
            {
              field  = "Microsoft.Storage/storageAccounts/networkAcls.defaultAction"
              equals = "allow"
            },
            {
              field  = "Microsoft.Storage/storageAccounts/isHnsEnabled"
              equals = false
            }
          ]
        }
      ]
    }
    then = {
      effect = "deny"
    }
  })
}

resource "azurerm_policy_assignment" "storage_no_public" {
  name                 = "disable-public-endpoints-storage"
  policy_definition_id = azurerm_policy_definition.storage_no_public.id
  scope                = data.azurerm_management_group.ccoe.id
  display_name       = "Disable Public Endpoints for Storage Accounts"
  description        = "Prevents storage accounts from having public blob or file endpoints"
}

# ============================================================
# Policy 6: Require encryption at rest
# ============================================================
resource "azurerm_policy_definition" "require_encryption" {
  name                 = "require-encryption-at-rest"
  policy_type          = "Custom"
  mode                 = "All"
  display_name       = "Require Encryption at Rest"
  description        = "Requires encryption at rest for all storage accounts, databases, and managed disks"

  policy_rule = jsonencode({
    if = {
      anyOf = [
        {
          allOf = [
            {
              field  = "type"
              equals = "Microsoft.Storage/storageAccounts"
            },
            {
              field  = "Microsoft.Storage/storageAccounts/encryption.keySource"
              notEquals = "Microsoft.Storage"
            }
          ]
        },
        {
          allOf = [
            {
              field  = "type"
              equals = "Microsoft.Sql/servers/databases"
            },
            {
              field  = "Microsoft.Sql/servers/databases/encryptionProtector"
              exists = false
            }
          ]
        },
        {
          allOf = [
            {
              field  = "type"
              equals = "Microsoft.Compute/disks"
            },
            {
              field  = "Microsoft.Compute/disks/encryption.settings[0].enabled"
              equals = false
            }
          ]
        }
      ]
    }
    then = {
      effect = "deny"
    }
  })
}

resource "azurerm_policy_assignment" "require_encryption" {
  name                 = "require-encryption-at-rest"
  policy_definition_id = azurerm_policy_definition.require_encryption.id
  scope                = data.azurerm_management_group.ccoe.id
  display_name       = "Require Encryption at Rest"
  description        = "Requires encryption at rest for all storage accounts, databases, and managed disks"
}

# ============================================================
# Policy 7: Restrict SSH/RDP inbound access
# ============================================================
resource "azurerm_policy_definition" "restrict_ssh_rdp" {
  name                 = "restrict-ssh-rdp-access"
  policy_type          = "Custom"
  mode                 = "All"
  display_name       = "Restrict SSH/RDP Inbound Access"
  description        = "Restricts SSH/RDP inbound access to jump boxes only"

  policy_rule = jsonencode({
    if = {
      anyOf = [
        {
          allOf = [
            {
              field  = "type"
              equals = "Microsoft.Network/networkSecurityGroups"
            },
            {
              anyOf = [
                {
                  anyOf = [
                    {
                      field  = "Microsoft.Network/networkSecurityGroups/securityRules[*].destinationPortRange"
                      equals = "22"
                    },
                    {
                      field  = "Microsoft.Network/networkSecurityGroups/securityRules[*].destinationPortRange"
                      equals = "3389"
                    }
                  ]
                },
                {
                  field  = "Microsoft.Network/networkSecurityGroups/securityRules[*].access"
                  equals = "Allow"
                },
                {
                  field  = "Microsoft.Network/networkSecurityGroups/securityRules[*].priority"
                  less = 4096
                }
              ]
            }
          ]
        }
      ]
    }
    then = {
      effect = "audit"
    }
  })
}

resource "azurerm_policy_assignment" "restrict_ssh_rdp" {
  name                 = "restrict-ssh-rdp-access"
  policy_definition_id = azurerm_policy_definition.restrict_ssh_rdp.id
  scope                = data.azurerm_management_group.ccoe.id
  display_name       = "Restrict SSH/RDP Inbound Access"
  description        = "Restricts SSH/RDP inbound access to jump boxes only"
}

# ============================================================
# Policy 8: Enable Defender for Cloud
# ============================================================
resource "azurerm_policy_definition" "enable_defender" {
  name                 = "enable-defender-for-cloud"
  policy_type          = "Custom"
  mode                 = "All"
  display_name       = "Enable Defender for Cloud"
  description        = "Enables Microsoft Defender for Cloud workload protection across all subscriptions"

  policy_rule = jsonencode({
    if = {
      anyOf = [
        {
          field  = "type"
          equals = "Microsoft.Security/pricings"
        },
        {
          field  = "type"
          equals = "Microsoft.Security/autoProvisioningSettings"
        }
      ]
    }
    then = {
      effect = "audit"
    }
  })
}

resource "azurerm_policy_assignment" "enable_defender" {
  name                 = "enable-defender-for-cloud"
  policy_definition_id = azurerm_policy_definition.enable_defender.id
  scope                = data.azurerm_management_group.ccoe.id
  display_name       = "Enable Defender for Cloud"
  description        = "Enables Microsoft Defender for Cloud workload protection across all subscriptions"
}

# ============================================================
# Policy 9: Require private endpoints for PaaS
# ============================================================
resource "azurerm_policy_definition" "require_private_endpoints" {
  name                 = "require-private-endpoints"
  policy_type          = "Custom"
  mode                 = "All"
  display_name       = "Require Private Endpoints for PaaS"
  description        = "Requires private endpoints for PaaS services for network isolation"

  policy_rule = jsonencode({
    if = {
      anyOf = [
        {
          allOf = [
            {
              field  = "type"
              equals = "Microsoft.Storage/storageAccounts"
            },
            {
              field  = "Microsoft.Storage/storageAccounts/privateEndpointConnections"
              exists = false
            }
          ]
        },
        {
          allOf = [
            {
              field  = "type"
              equals = "Microsoft.Sql/servers"
            },
            {
              field  = "Microsoft.Sql/servers/privateEndpointConnections"
              exists = false
            }
          ]
        },
        {
          allOf = [
            {
              field  = "type"
              equals = "Microsoft.KeyVault/vaults"
            },
            {
              field  = "Microsoft.KeyVault/vaults/privateEndpointConnections"
              exists = false
            }
          ]
        }
      ]
    }
    then = {
      effect = "audit"
    }
  })
}

resource "azurerm_policy_assignment" "require_private_endpoints" {
  name                 = "require-private-endpoints"
  policy_definition_id = azurerm_policy_definition.require_private_endpoints.id
  scope                = data.azurerm_management_group.ccoe.id
  display_name       = "Require Private Endpoints for PaaS"
  description        = "Requires private endpoints for PaaS services for network isolation"
}

# ============================================================
# Policy 10: Deny resource deletion without approval
# ============================================================
resource "azurerm_policy_definition" "deny_deletion" {
  name                 = "deny-resource-deletion"
  policy_type          = "Custom"
  mode                 = "All"
  display_name       = "Deny Resource Deletion Without Approval"
  description        = "Denies resource deletion without proper change control approval"

  policy_rule = jsonencode({
    if = {
      field  = "request.operation"
      equals = "Microsoft.Resources/subscriptions/resourceGroups/delete"
    }
    then = {
      effect = "deny"
    }
  })
}

resource "azurerm_policy_assignment" "deny_deletion" {
  name                 = "deny-resource-deletion"
  policy_definition_id = azurerm_policy_definition.deny_deletion.id
  scope                = data.azurerm_management_group.ccoe.id
  display_name       = "Deny Resource Deletion Without Approval"
  description        = "Denies resource deletion without proper change control approval"
}

# ============================================================
# Data Source: Management Group
# ============================================================
data "azurerm_management_group" "ccoe" {
  name = var.management_group_id
}

# ============================================================
# Outputs
# ============================================================
output "policy_assignments" {
  description = "List of all policy assignments created"
  value = [
    azurerm_policy_assignment.allowed_resource_types,
    azurerm_policy_assignment.require_tags,
    azurerm_policy_assignment.restrict_locations,
    azurerm_policy_assignment.require_nsgs,
    azurerm_policy_assignment.storage_no_public,
    azurerm_policy_assignment.require_encryption,
    azurerm_policy_assignment.restrict_ssh_rdp,
    azurerm_policy_assignment.enable_defender,
    azurerm_policy_assignment.require_private_endpoints,
    azurerm_policy_assignment.deny_deletion
  ]
}

output "management_group_id" {
  description = "The management group ID policies were assigned to"
  value       = data.azurerm_management_group.ccoe.id
}
