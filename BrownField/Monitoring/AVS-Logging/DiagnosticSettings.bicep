targetScope = 'subscription'

param Location string = 'North Europe'
param Prefix string = 'kk-avs'
param PrivateCloudName string = 'kk-avs-SDDC'
param PrivateCloudResourceGroupName string = 'kk-avs-PrivateCloud'
param WorkspaceName string = 'kk-avs-Workspace'


resource OperationalResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: '${Prefix}-Operational'
  location: Location
}

resource PrivateCloudResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' existing = {
  name: PrivateCloudResourceGroupName
}

module Workspace 'Modules/Workspace.bicep' = {
  scope: OperationalResourceGroup
  name: '${deployment().name}-Workspace'
  params: {
    WorkspaceName: WorkspaceName
    Location: Location
  }
}

module AVSDiagnostics 'Modules/AVSDiagnostics.bicep' = {
  scope: PrivateCloudResourceGroup
  name: '${deployment().name}-AVSDiagnostics'
  params: {
    PrivateCloudName: PrivateCloudName
    WorkspaceId: Workspace.outputs.WorkspaceId
  }
}

module ActivityLogDiagnostics 'Modules/ActivityLogDiagnostics.bicep' = {
  name: '${deployment().name}-ActivityLogDiagnostics'
  params: {
    WorkspaceId: Workspace.outputs.WorkspaceId
  }
}
