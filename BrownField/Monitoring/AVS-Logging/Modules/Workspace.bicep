param WorkspaceName string = ''
param Location string = resourceGroup().location

resource Workspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: WorkspaceName
  location: Location
}

output WorkspaceId string = Workspace.id
