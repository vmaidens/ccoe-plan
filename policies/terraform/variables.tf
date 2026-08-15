# CCoE Terraform Variables
# Generated: 2026-08-15
# Author: Vince Maidens

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

variable "environment" {
  description = "Environment tag value (default: production)"
  type        = string
  default     = "production"
}

variable "cost_centre" {
  description = "Cost centre tag value (default: CCoE)"
  type        = string
  default     = "CCoE"
}

variable "project" {
  description = "Project tag value (default: CCoE Build)"
  type        = string
  default     = "CCoE Build"
}

variable "data_classification" {
  description = "Data classification tag value (default: Internal)"
  type        = string
  default     = "Internal"
}

variable "allowed_locations" {
  description = "List of allowed Azure regions for resource deployment"
  type        = list(string)
  default     = ["uksouth", "ukwest"]
}

variable "allowed_resource_types" {
  description = "List of allowed Azure resource types"
  type        = list(string)
  default = [
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

variable "required_tags" {
  description = "List of required tags for all resources"
  type        = list(string)
  default     = ["costCentre", "environment", "project", "dataClassification"]
}
