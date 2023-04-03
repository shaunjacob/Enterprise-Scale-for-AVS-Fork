targetScope = 'subscription'

param Location string = 'canadacentral'
param Prefix string = 'SJT3'
param VNetExists bool = true
param NewVNetAddressSpace string = ''
param NewVnetNewGatewaySubnetAddressPrefix string = ''
param NewNetworkName string = ''
param NewNetworkResourceGroupName string = 'Test-vnetrg'
param ExistingVnetName string = 'AVS-vnet'
param ExistingVnetId string = '/subscriptions/1caa5ab4-523f-4851-952b-1b689c48fae9/resourceGroups/AVS-Network/providers/Microsoft.Network/virtualNetworks/AVS-vnet'
param ExistingGatewayName string = ''

var ExistingNetworkResourceGroupName = split(ExistingVnetId,'/')[4]

resource NewNetworkResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = if (!VNetExists) {
  name: NewNetworkResourceGroupName
  location: Location
}

resource ExistingNetworkResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' existing = if (VNetExists) {
  name: ExistingNetworkResourceGroupName
}

module NewNetwork 'AzureNetworking/NewVNetWithGW.bicep' = if (!VNetExists) {
  scope: NewNetworkResourceGroup
  name: '${deployment().name}-NewNetwork'
  params: {
    Prefix: Prefix
    Location: Location
    NewNetworkName: NewNetworkName
    NewVNetAddressSpace: NewVNetAddressSpace
    NewVnetNewGatewaySubnetAddressPrefix: NewVnetNewGatewaySubnetAddressPrefix
  }
}

module ExistingNetwork 'AzureNetworking/ExistingVNetWithGW.bicep' = if (VNetExists) {
  scope: resourceGroup(ExistingNetworkResourceGroupName)
  name: '${deployment().name}-ExistingNetwork'
  params: {
    Prefix: Prefix
    Location: ExistingNetworkResourceGroup.location
    ExistingVnetName : ExistingVnetName
    ExistingGatewayName : ExistingGatewayName
  }
}

output GatewayName string = (!VNetExists) ? NewNetwork.outputs.GatewayName : ExistingNetwork.outputs.GatewayName
output VNetName string = (!VNetExists) ? NewNetwork.outputs.VNetName : ExistingNetwork.outputs.VNetName
output VNetResourceId string = (!VNetExists) ? NewNetwork.outputs.VNetResourceId : ExistingNetwork.outputs.VNetResourceId
output NetworkResourceGroup string = (!VNetExists) ? NewNetworkResourceGroup.name : ExistingNetworkResourceGroup.name
output NetworkResourceGroupLocation string = (!VNetExists) ? NewNetworkResourceGroup.location : ExistingNetworkResourceGroup.location

