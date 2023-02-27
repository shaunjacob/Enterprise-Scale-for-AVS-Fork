//Bool
param GatewayExists bool = false
param GatewaySubnetExists bool = true

//String
param Location string = 'canadacentral'
param Prefix string = 'SJT4'
param ExistingVnetName string = 'AVS-vNet'
param ExistingGatewayName string = ''
param NewGatewaySku string = 'Standard'
param ExistingGatewaySubnetId string = ''

var ExistingVnetNewGatewayName = '${Prefix}-gw'

//Existing Gateway
resource ExistingGateway 'Microsoft.Network/virtualNetworkGateways@2021-08-01' existing = if (GatewayExists) {
  name: ExistingGatewayName
}

// Existing VNet Workflow
resource ExistingVNet 'Microsoft.Network/virtualNetworks@2021-08-01' existing = if (!GatewayExists) {
  name: ExistingVnetName
}

resource NewGatewayPIP 'Microsoft.Network/publicIPAddresses@2021-08-01' = if (!GatewayExists) {
  name: '${ExistingVnetNewGatewayName}-pip'
  location: Location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
  sku: {
    name: 'Basic'
    tier: 'Regional'
  }
}

resource ExistingVnetNewGateway 'Microsoft.Network/virtualNetworkGateways@2021-08-01' = if (!GatewayExists) {
  name: ExistingVnetNewGatewayName
  location: Location
  properties: {
    gatewayType: 'ExpressRoute'
    sku: {
      name: NewGatewaySku
      tier: NewGatewaySku
    }
    ipConfigurations: [
      {
        name: 'default'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: (GatewaySubnetExists) ? ExistingGatewaySubnetId : ''
          }
          publicIPAddress: {
            id: NewGatewayPIP.id
          }
        }
      }
    ]
  }
}


output VNetName string = ExistingVNet.name
output GatewayName string = (!GatewayExists) ? ExistingVnetNewGateway.name : ExistingGateway.name
output ExistingGatewayName string = ExistingGateway.name
output VNetResourceId string = ExistingVNet.id
