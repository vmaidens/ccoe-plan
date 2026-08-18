// ============================================================
// CCoE Landing Zone — Hub-Spoke Networking (UK South)
//
// Topology:
//   HUB 10.10.0.0/20
//     - AzureBastionSubnet  10.10.0.0/27
//     - GatewaySubnet       10.10.1.0/24   (ExpressRoute, added later)
//     - Management          10.10.2.0/24   (admin access via Bastion only)
//   SPOKES per environment (dev/test/prod), each /23:
//     - App subnet  first /24 of the block
//     - Data subnet second /24 of the block
//
// Access model: NO public IPs on workloads. All admin access
// via Azure Bastion from the hub. UDRs for ExpressRoute routing
// are created but disabled until the ER circuit lands.
// ============================================================

param prefix string = 'ccoe'
param location string = 'uksouth'
@description('Enable 0.0.0.0/0 -> VirtualNetworkGateway routes once the ExpressRoute circuit exists')
param enableErRouting bool = false

var hubAddressSpace = '10.10.0.0/20'
var bastionCidr = '10.10.0.0/27'
var gatewayCidr = '10.10.1.0/24'
var managementCidr = '10.10.2.0/24'

// Spoke address plan (explicit CIDRs — no runtime string manipulation)
var spokePlan = [
  { env: 'dev', cidr: '10.20.0.0/23', appCidr: '10.20.0.0/24', dataCidr: '10.20.0.128/24' }
  { env: 'test', cidr: '10.20.4.0/23', appCidr: '10.20.4.0/24', dataCidr: '10.20.4.128/24' }
  { env: 'prod', cidr: '10.20.8.0/23', appCidr: '10.20.8.0/24', dataCidr: '10.20.8.128/24' }
]

// ------------------------------------------------------------
// Hub VNet (subnets declared separately so NSGs can be attached)
// ------------------------------------------------------------
resource hubVnet 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: '${prefix}-hub-vnet-${location}'
  location: location
  tags: {
    environment: 'shared'
    project: 'ccoe-landing-zone'
    dataClassification: 'internal'
  }
  properties: {
    addressSpace: {
      addressPrefixes: [ hubAddressSpace ]
    }
  }
}

// Bastion host (admin access without public workload IPs)
resource bastion 'Microsoft.Network/bastionHosts@2024-05-01' = {
  name: '${prefix}-bastion-${location}'
  location: location
  tags: {
    environment: 'shared'
    project: 'ccoe-landing-zone'
  }
  properties: {} // Bastion auto-provisions into AzureBastionSubnet
}

// ------------------------------------------------------------
// Hub NSG — allow Bastion -> Management (SSH/RDP), deny everything else inbound
// ------------------------------------------------------------
resource hubNsg 'Microsoft.Network/networkSecurityGroups@2024-05-01' = {
  name: '${prefix}-hub-nsg-${location}'
  location: location
  tags: {
    environment: 'shared'
    project: 'ccoe-landing-zone'
  }
  properties: {
    securityRules: [
      {
        name: 'AllowBastionToManagement'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRanges: [ '22', '3389' ]
          sourceAddressPrefixes: [ bastionCidr ]
          destinationAddressPrefix: managementCidr
        }
      }
      {
        name: 'DenyAllOtherInbound'
        properties: {
          priority: 4098
          direction: 'Inbound'
          access: 'Deny'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRanges: [ '*' ]
          sourceAddressPrefixes: [ '*' ]
          destinationAddressPrefixes: [ '*' ]
        }
      }
    ]
  }
}

// Hub subnets (declared separately so NSG can be attached to Management)
resource hubBastionSubnet 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' = {
  parent: hubVnet
  name: 'AzureBastionSubnet'
  properties: {
    addressPrefix: bastionCidr
  }
}

resource hubGatewaySubnet 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' = {
  parent: hubVnet
  name: 'GatewaySubnet'
  properties: {
    addressPrefix: gatewayCidr
  }
}

resource hubMgmtSubnet 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' = {
  parent: hubVnet
  name: 'Management'
  properties: {
    addressPrefix: managementCidr
    networkSecurityGroup: { id: hubNsg.id }
  }
}

// ------------------------------------------------------------
// Spoke VNets (loop over environments)
// ------------------------------------------------------------
resource spokeVnets 'Microsoft.Network/virtualNetworks@2024-05-01' = [ for s in spokePlan: {
  name: '${prefix}-spoke-${s.env}-${location}'
  location: location
  tags: {
    environment: s.env
    project: 'ccoe-landing-zone'
    dataClassification: s.env == 'prod' ? 'official-sensitive' : 'internal'
  }
  properties: {
    addressSpace: {
      addressPrefixes: [ s.cidr ]
    }
  }
}]

// Spoke NSGs — allow hub Management inbound (SSH/RDP), deny everything else
resource spokeNsgs 'Microsoft.Network/networkSecurityGroups@2024-05-01' = [ for s in spokePlan: {
  name: '${prefix}-spoke-${s.env}-nsg-${location}'
  location: location
  tags: {
    environment: s.env
    project: 'ccoe-landing-zone'
  }
  properties: {
    securityRules: [
      {
        name: 'AllowHubManagementInbound'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRanges: [ '22', '3389' ]
          sourceAddressPrefixes: [ managementCidr ]
          destinationAddressPrefix: '*'
        }
      }
      {
        name: 'DenyAllOtherInbound'
        properties: {
          priority: 4098
          direction: 'Inbound'
          access: 'Deny'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRanges: [ '*' ]
          sourceAddressPrefixes: [ '*' ]
          destinationAddressPrefixes: [ '*' ]
        }
      }
    ]
  }
}]

// Spoke App subnets (NSG attached) and Data subnets (tighter rules per workload later)
resource spokeAppSubnets 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' = [ for s in spokePlan: {
  parent: spokeVnets[loopIndex()]
  name: 'App'
  properties: {
    addressPrefix: s.appCidr
    networkSecurityGroup: { id: spokeNsgs[loopIndex()].id }
  }
}]

resource spokeDataSubnets 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' = [ for s in spokePlan: {
  parent: spokeVnets[loopIndex()]
  name: 'Data'
  properties: {
    addressPrefix: s.dataCidr
  }
}]

// ------------------------------------------------------------
// Peering: hub <-> each spoke (bidirectional)
// ------------------------------------------------------------
resource hubPeerings 'Microsoft.Network/virtualNetworks/peering@2024-05-01' = [ for s in spokePlan: {
  parent: hubVnet
  name: '${prefix}-hub-to-${s.env}'
  properties: {
    remoteVirtualNetwork: { id: spokeVnets[loopIndex()].id }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    useRemoteGateways: false
  }
}]

resource spokePeerings 'Microsoft.Network/virtualNetworks/peering@2024-05-01' = [ for s in spokePlan: {
  parent: spokeVnets[loopIndex()]
  name: '${prefix}-${s.env}-to-hub'
  properties: {
    remoteVirtualNetwork: { id: hubVnet.id }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    useRemoteGateways: false
  }
}]

// ------------------------------------------------------------
// UDRs — ExpressRoute routing placeholder.
// Disabled by default so internet egress keeps working until the
// ER circuit + gateway exist; flip enableErRouting=true to activate.
// ------------------------------------------------------------
resource udrs 'Microsoft.Network/userDefinedRoutes@2024-05-01' = [ for s in spokePlan: {
  name: '${prefix}-spoke-${s.env}-udr-${location}'
  location: location
  tags: {
    environment: s.env
    project: 'ccoe-landing-zone'
  }
  properties: {
    routes: enableErRouting ? [
      {
        name: 'ToSaaSViaHubGateway'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualNetworkGateway'
        }
      }
    ] : []
  }
}]

// ------------------------------------------------------------
// Outputs (record in the delivery log)
// ------------------------------------------------------------
output hubVnetId string = hubVnet.id
output bastionSubnetName string = 'AzureBastionSubnet'
output spokeVnetIds object = {
  dev: spokeVnets[0].id
  test: spokeVnets[1].id
  prod: spokeVnets[2].id
}
