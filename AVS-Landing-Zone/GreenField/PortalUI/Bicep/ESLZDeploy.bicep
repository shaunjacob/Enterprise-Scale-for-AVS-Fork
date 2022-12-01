targetScope = 'subscription'

@description('The prefix to use on resources inside this template')
@minLength(1)
@maxLength(20)
param Prefix string = 'AVS'
@description('Optional: The location the private cloud should be deployed to, by default this will be the location of the deployment')
param Location string = deployment().location

//Private Cloud
@description('Set this to false if the Private Cloud already exists')
param DeployPrivateCloud bool = false
@description('Optional: The location the private cloud should be deployed to, by default this will be the location of the deployment')
param PrivateCloudName string = ''
@description('Optional: The location the private cloud should be deployed to, by default this will be the location of the deployment')
param PrivateCloudResourceGroupName string = 'avs-rg'
@description('The address space used for the AVS Private Cloud management networks. Must be a non-overlapping /22')
param PrivateCloudAddressSpace string = ''
@description('The SKU that should be used for the first cluster, ensure you have quota for the given SKU before deploying')
@allowed([
  'AV36'
  'AV36T'
  'AV36P'
  'AV52'
])
param PrivateCloudSKU string = 'AV36'
@description('The number of nodes to be deployed in the first/default cluster, ensure you have quota before deploying')
param PrivateCloudHostCount int = 3
@description('Existing Private Cloud Name')
param ExistingPrivateCloudName string = ''
@description('Existing Private Cloud Id')
param ExistingPrivateCloudResourceId string = ''

//Azure Networking
@description('Set this to true if you are redeploying, and the VNet already exists')
param VNetExists bool = false
@description('A string value to skip the networking deployment')
param DeployNetworking bool = false
@description('Set this to true if you are redeploying, and the VNet already exists')
param GatewayExists bool = false
@description('Does the GatewaySubnet Exist')
param GatewaySubnetExists bool = false
@description('The address space used for the VNet attached to AVS. Must be non-overlapping with existing networks')
param NewVNetAddressSpace string = ''
@description('The subnet CIDR used for the Gateway Subnet. Must be a /24 or greater within the VNetAddressSpace')
param NewVnetNewGatewaySubnetAddressPrefix string = ''
@description('The Existing VNet name')
param ExistingVnetName string = ''
@description('The Existing Gateway name')
param ExistingGatewayName string = ''
@description('The existing vnet gatewaysubnet id')
param ExistingGatewaySubnetId string = ''
@description('The existing vnet new gatewaysubnet prefix')
param ExistingVnetNewGatewaySubnetPrefix string = ''

param NetworkName string = ''
param NetworkResourceGroupName string = ''


//Jumpbox
@description('Should a Jumpbox & Bastion be deployed to access the Private Cloud')
param DeployJumpbox bool = false
@description('Username for the Jumpbox VM')
param JumpboxUsername string = 'avsjump'
@secure()
@description('Password for the Jumpbox VM, can be changed later')
param JumpboxPassword string = ''
@description('The subnet CIDR used for the Jumpbox VM Subnet. Must be a /26 or greater within the VNetAddressSpace')
param JumpboxSubnet string = ''
@description('The sku to use for the Jumpbox VM, must have quota for this within the target region')
param JumpboxSku string = 'Standard_D2s_v3'
@description('The subnet CIDR used for the Bastion Subnet. Must be a /26 or greater within the VNetAddressSpace')
param BastionSubnet string = ''

// Monitoring Module Parameters
param DeployMonitoring bool = false
param DeployDashboard bool = false
param DeployMetricAlerts bool = false
param DeployServiceHealth bool = false
param AlertEmails string = ''
param CPUUsageThreshold int
param MemoryUsageThreshold int
param StorageUsageThreshold int

//Diagnostic Module Parameters
param DeployDiagnostics bool = false
param DeployAVSLogsWorkspace bool = false
param DeployActivityLogDiagnostics bool = false
param DeployAVSLogsStorage bool = false
param DeployWorkbook bool = false
param DeployWorkspace bool = false
param NewWorkspaceName string = ''
param NewStorageAccountName string = ''
param DeployStorageAccount bool = false
param ExistingWorkspaceId string = ''
param ExistingStorageAccountId string = ''
param StorageRetentionDays int

//Addons
@description('Should HCX be deployed as part of the deployment')
param DeployHCX bool = true
@description('Should SRM be deployed as part of the deployment')
param DeploySRM bool = false
@description('License key to be used if SRM is deployed')
param SRMLicenseKey string = ''
@minValue(1)
@maxValue(10)
@description('Number of vSphere Replication Servers to be created if SRM is deployed')
param VRServerCount int = 1

@description('Opt-out of deployment telemetry')
param TelemetryOptOut bool = false

//Variables
var deploymentPrefix = 'AVS-${uniqueString(deployment().name, Location)}'
var varCuaid = '1cf4a3e3-529c-4fb2-ba6a-63dff7d71586'

module AVSCore 'Modules/AVSCore.bicep' = {
  name: '${deploymentPrefix}-AVS'
  params: {
    Location: Location
    PrivateCloudName: PrivateCloudName
    PrivateCloudResourceGroupName: PrivateCloudResourceGroupName
    PrivateCloudAddressSpace: PrivateCloudAddressSpace
    PrivateCloudHostCount: PrivateCloudHostCount
    PrivateCloudSKU: PrivateCloudSKU
    DeployPrivateCloud : DeployPrivateCloud
    ExistingPrivateCloudResourceId : ExistingPrivateCloudResourceId
  }
}

module AzureNetworking 'Modules/AzureNetworking.bicep' = if (DeployNetworking) {
  name: '${deploymentPrefix}-AzureNetworking'
  params: {
    Prefix: Prefix
    Location: Location
    VNetExists: VNetExists
    NetworkName: NetworkName
    NetworkResourceGroupName: NetworkResourceGroupName
    ExistingVnetName : ExistingVnetName
    GatewayExists : GatewayExists
    ExistingGatewayName : ExistingGatewayName
    GatewaySubnetExists : GatewaySubnetExists
    ExistingGatewaySubnetId : ExistingGatewaySubnetId
    ExistingVnetNewGatewaySubnetPrefix : ExistingVnetNewGatewaySubnetPrefix
    NewVNetAddressSpace: NewVNetAddressSpace
    NewVnetNewGatewaySubnetAddressPrefix: NewVnetNewGatewaySubnetAddressPrefix
  }
}

module VNetConnection 'Modules/VNetConnection.bicep' = if (DeployNetworking) {
  name: '${deploymentPrefix}-VNetConnection'
  params: {
    GatewayName: DeployNetworking ? AzureNetworking.outputs.GatewayName : 'none'
    NetworkResourceGroup: DeployNetworking ? AzureNetworking.outputs.NetworkResourceGroup : 'none'
    VNetPrefix: Prefix
    PrivateCloudName: DeployPrivateCloud ? AVSCore.outputs.PrivateCloudName : ExistingPrivateCloudName
    PrivateCloudResourceGroup: AVSCore.outputs.PrivateCloudResourceGroupName 
    Location: Location
  }
}

module Jumpbox 'Modules/JumpBox.bicep' = if (DeployJumpbox) {
  name: '${deploymentPrefix}-Jumpbox'
  params: {
    Prefix: Prefix
    Location: Location
    Username: JumpboxUsername
    Password: JumpboxPassword
    VNetName: DeployNetworking ? AzureNetworking.outputs.VNetName : ''
    VNetResourceGroup: DeployNetworking ? AzureNetworking.outputs.NetworkResourceGroup : ''
    BastionSubnet: BastionSubnet
    JumpboxSubnet: JumpboxSubnet
    JumpboxSku: JumpboxSku
  }
}

module OperationalMonitoring 'Modules/Monitoring.bicep' = if ((DeployMonitoring)) {
  name: '${deploymentPrefix}-Monitoring'
  params: {
    AlertEmails: AlertEmails
    Prefix: Prefix
    Location: Location
    DeployMetricAlerts : DeployMetricAlerts
    DeployServiceHealth : DeployServiceHealth
    DeployDashboard : DeployDashboard
    DeployWorkbook : DeployWorkbook
    PrivateCloudName : DeployPrivateCloud ? AVSCore.outputs.PrivateCloudName : ExistingPrivateCloudName
    PrivateCloudResourceId : DeployPrivateCloud ? AVSCore.outputs.PrivateCloudResourceId : ExistingPrivateCloudResourceId
    CPUUsageThreshold: CPUUsageThreshold
    MemoryUsageThreshold: MemoryUsageThreshold
    StorageUsageThreshold: StorageUsageThreshold
  }
}

module Diagnostics 'Modules/Diagnostics.bicep' = if ((DeployDiagnostics)) {
  name: '${deploymentPrefix}-Diagnostics'
  params: {
    Location: Location
    Prefix: Prefix
    DeployAVSLogsWorkspace: DeployAVSLogsWorkspace
    DeployActivityLogDiagnostics: DeployActivityLogDiagnostics
    DeployAVSLogsStorage: DeployAVSLogsStorage
    DeployWorkspace: DeployWorkspace
    NewWorkspaceName: NewWorkspaceName
    DeployStorageAccount: DeployStorageAccount
    NewStorageAccountName: NewStorageAccountName
    PrivateCloudName: DeployPrivateCloud ? AVSCore.outputs.PrivateCloudName : ExistingPrivateCloudName
    PrivateCloudResourceId: DeployPrivateCloud ? AVSCore.outputs.PrivateCloudResourceId : ExistingPrivateCloudResourceId
    ExistingWorkspaceId: ExistingWorkspaceId
    ExistingStorageAccountId: ExistingStorageAccountId
    StorageRetentionDays: StorageRetentionDays
  }
}

module Addons 'Modules/AVSAddons.bicep' = if ((DeployHCX) || (DeploySRM)) {
  name: '${deploymentPrefix}-AVSAddons'
  params: {
    PrivateCloudName: DeployPrivateCloud ? AVSCore.outputs.PrivateCloudName : ExistingPrivateCloudName
    PrivateCloudResourceGroup: AVSCore.outputs.PrivateCloudResourceGroupName
    DeployHCX: DeployHCX
    DeploySRM: DeploySRM
    SRMLicenseKey: SRMLicenseKey
    VRServerCount: VRServerCount
  }
}

// Optional Deployment for Customer Usage Attribution
module modCustomerUsageAttribution '../../../../BrownField/Addons/CUAID/customerUsageAttribution/cuaIdSubscription.bicep' = if (!TelemetryOptOut) {
  #disable-next-line no-loc-expr-outside-params
  name: 'pid-${varCuaid}-${uniqueString(deployment().name, Location)}'
  params: {}
}
