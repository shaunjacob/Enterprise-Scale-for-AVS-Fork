param Location string
param Prefix string
param tags object

@description('The unique guid for this workbook instance')
param workbookId string = newGuid()

var WorkbookDisplayName = '${Prefix}-Workbook-v33-${uniqueString(deployment().name, Location)}'

var workbookContent = {
  version: 'Notebook/1.0'
  items: [
    {
      type: 9
      content: {
        version: 'KqlParameterItem/1.0'
        crossComponentResources: [
          '{Workspace}'
        ]
        parameters: [
          {
            id: '0e322c64-be41-4f52-ba5b-df55cf94e41d'
            version: 'KqlParameterItem/1.0'
            name: 'TimeRange'
            type: 4
            isRequired: true
            value: {
              durationMs: 14400000
            }
            typeSettings: {
              selectableValues: [
                {
                  durationMs: 3600000
                }
                {
                  durationMs: 14400000
                }
                {
                  durationMs: 43200000
                }
                {
                  durationMs: 86400000
                }
                {
                  durationMs: 172800000
                }
                {
                  durationMs: 259200000
                }
                {
                  durationMs: 604800000
                }
                {
                  durationMs: 1209600000
                }
                {
                  durationMs: 2592000000
                }
                {
                  durationMs: 5184000000
                }
                {
                  durationMs: 7776000000
                }
              ]
              allowCustom: true
            }
            timeContext: {
              durationMs: 86400000
            }
          }
          {
            id: '69be2f0e-ec9f-4cb2-bef0-e437c0b01789'
            version: 'KqlParameterItem/1.0'
            name: 'Subscription'
            type: 6
            isRequired: true
            multiSelect: true
            quote: '\''
            delimiter: ','
            query: 'where type =~ \'microsoft.avs/privateclouds\'\r\n| summarize Count = count() by subscriptionId\r\n\t| order by Count desc\r\n\t| extend Rank = row_number()\r\n\t| project value = subscriptionId, label = subscriptionId, selected = Rank == 1'
            crossComponentResources: [
              'value::all'
            ]
            typeSettings: {
              additionalResourceOptions: [
                'value::1'
                'value::all'
              ]
              showDefault: false
            }
            timeContext: {
              durationMs: 86400000
            }
            queryType: 1
            resourceType: 'microsoft.resourcegraph/resources'
            value: [
              'value::all'
            ]
          }
          {
            id: '569baca3-cd50-4a2c-a701-423682ee14fb'
            version: 'KqlParameterItem/1.0'
            name: 'Workspace'
            type: 5
            isRequired: true
            multiSelect: true
            quote: '\''
            delimiter: ','
            query: 'where type =~ \'microsoft.operationalinsights/workspaces\'\r\n| project id'
            crossComponentResources: [
              '{Subscription}'
            ]
            typeSettings: {
              additionalResourceOptions: [
                'value::all'
              ]
              showDefault: false
            }
            timeContext: {
              durationMs: 86400000
            }
            queryType: 1
            resourceType: 'microsoft.resourcegraph/resources'
            value: [
              'value::all'
            ]
          }
          {
            id: '74094954-a20f-4f95-bf23-5d1d232a5af5'
            version: 'KqlParameterItem/1.0'
            name: 'AVSInstance'
            label: 'AVS Instance'
            type: 2
            isRequired: true
            multiSelect: true
            quote: '\''
            delimiter: ','
            query: 'resources \r\n| where type contains \'microsoft.avs/privatecloud\'\r\n| project value = id, label = name'
            crossComponentResources: [
              '{Subscription}'
            ]
            typeSettings: {
              additionalResourceOptions: [
                'value::1'
                'value::all'
              ]
              showDefault: false
            }
            timeContext: {
              durationMs: 86400000
            }
            queryType: 1
            resourceType: 'microsoft.resourcegraph/resources'
            value: [
              'value::all'
            ]
          }
          {
            id: '85d960b8-e89c-42ee-bf8c-fa95ce925c5d'
            version: 'KqlParameterItem/1.0'
            name: 'ChangeLog'
            label: 'Change Log'
            type: 10
            isRequired: true
            typeSettings: {
              additionalResourceOptions: []
              showDefault: false
            }
            jsonData: '[\r\n { "value": "Yes", "label": "Yes"},\r\n { "value": "No", "label": "No", "selected":true }\r\n]'
            timeContext: {
              durationMs: 0
            }
            timeContextFromParameter: 'TimeRange'
          }
        ]
        style: 'pills'
        queryType: 0
        resourceType: 'microsoft.operationalinsights/workspaces'
      }
      name: 'parameters - 0'
    }
    {
      type: 1
      content: {
        json: '# This workbook shows information relevant to your deployed AVS Private Clouds'
      }
      name: 'text - 4'
    }
    {
      type: 1
      content: {
        json: '# Change Log\r\n\r\n### Version 1\r\nThis is the original version of the AVS workbooks and features:\r\n- A summary of the AVS solutions deployed\r\n- Metrics performance view\r\n- Activity section related to AVS\r\n\r\n### Version 2\r\nAdded VMware resource view\r\n\r\n### Version 3 \r\nAdded VM Information \r\n\r\n### Version 4\r\nAdded Alert information\r\n\r\n### Version 5\r\nAdded help for configuring Alerts\r\n\r\n### Version 6\r\n- Added Advisor recommendations\r\n- Added impact filter for Advisor recommendations\r\n- Added status VM tools\r\n\r\n### Version 7\r\nAdded help for Activity tab view\r\n\r\n### Version 8\r\n- Added syslog information\r\n- Enabled more info layout  for syslog\r\n- Presented workspace parameter in general as visible instead of hidden\r\n\r\n### Version 9\r\nAdded map location view including filter for AVS instace and VM views\r\n\r\n### Version 10\r\n- Added AVS quota map and information\r\n- Added additional paramater to filter AVS instance at root level for summary and locations views\r\n- Added vCenter filter to VM view\r\n- Bugfixes and performance enhancements\r\n\r\n### Version 11 (Enhanced Edition)\r\n- **NEW Metrics Engine**: Updated CPU and Memory metrics to use improved reliability engine\r\n- **Networking Tab**: ExpressRoute status, GlobalReach connections, Authorizations\r\n- **Security Tab**: NSX Firewall logs analysis, security event timeline\r\n- **Storage Tab**: ANF datastore monitoring, vSAN health\r\n- **BCDR Tab**: HCX, SRM, and vSphere Replication addon status\r\n- **Arc Integration Tab**: Guest management, Azure extensions status\r\n- **Capacity & Cost Tab**: SKU breakdown, host count trends, cost estimation\r\n- **Enhanced Clusters**: Detailed cluster metrics by cluster name\r\n- **Additional Regions**: Added missing Azure regions for quota information\r\n\r\n### Version 12 (Consolidated)\r\n- Consolidated 15 tabs into 6 streamlined tabs for better UX\r\n- **Overview**: Summary + Locations + Quota + Capacity\r\n- **Resources**: Resources + Virtual Machines + Arc Integration\r\n- **Operations**: Alerts + SysLog + Activity + Advisor\r\n- **Networking**: Networking + Security (NSX firewall)\r\n- **Storage**: vSAN and ANF datastores\r\n- **BCDR**: HCX, SRM, vSphere Replication addons\r\n\r\n### Version 13\r\n- Added friendly empty state messages for Alerts (0 alerts - AVS healthy)\r\n- Added friendly empty state messages for Severity Summary\r\n- Fixed Advisor query filter to correctly identify AVS resources\r\n- Added No recommendations message for Advisor'
      }
      conditionalVisibility: {
        parameterName: 'ChangeLog'
        comparison: 'isEqualTo'
        value: 'Yes'
      }
      name: 'text - 5'
    }
    {
      type: 11
      content: {
        version: 'LinkItem/1.0'
        style: 'tabs'
        links: [
          {
            id: 'ce43bd96-a673-4b26-a580-023b0ff3ba86'
            cellValue: 'Tab'
            linkTarget: 'parameter'
            linkLabel: 'Overview'
            subTarget: 'Overview'
            style: 'link'
          }
          {
            id: '22d35b15-a48c-4b5f-b450-af89b26ae824'
            cellValue: 'Tab'
            linkTarget: 'parameter'
            linkLabel: 'Resources'
            subTarget: 'Resources'
            style: 'link'
          }
          {
            id: '0a60794e-c6ef-4cbc-91db-cb2dca983938'
            cellValue: 'Tab'
            linkTarget: 'parameter'
            linkLabel: 'Operations'
            subTarget: 'Operations'
            style: 'link'
          }
          {
            id: 'b1c2d3e4-f5a6-4b7c-8d9e-0f1a2b3c4d5e'
            cellValue: 'Tab'
            linkTarget: 'parameter'
            linkLabel: 'Networking'
            subTarget: 'Networking'
            style: 'link'
          }
          {
            id: 'd3e4f5a6-b7c8-4d9e-0f1a-2b3c4d5e6f7a'
            cellValue: 'Tab'
            linkTarget: 'parameter'
            linkLabel: 'Storage'
            subTarget: 'Storage'
            style: 'link'
          }
        ]
      }
      name: 'links - 3'
    }
    {
      type: 12
      content: {
        version: 'NotebookGroup/1.0'
        groupType: 'editable'
        items: [
          {
            type: 1
            content: {
              json: '## Overview Dashboard\r\nAt-a-glance view of your Azure VMware Solution environment health, utilization, and alerts.'
            }
            name: 'text - overview-header'
          }
          {
            type: 3
            content: {
              version: 'KqlItem/1.0'
              query: 'resources\r\n| where type =~ "microsoft.avs/privateclouds"\r\n| where id in ({AVSInstance})\r\n| count\r\n| project Label = "Private Clouds", Value = Count'
              size: 4
              title: 'Total Private Clouds'
              queryType: 1
              resourceType: 'microsoft.resourcegraph/resources'
              crossComponentResources: [
                '{Subscription}'
              ]
              visualization: 'tiles'
              tileSettings: {
                showBorder: false
                titleContent: {
                  columnMatch: 'Label'
                  formatter: 1
                }
                leftContent: {
                  columnMatch: 'Value'
                  formatter: 12
                  formatOptions: {
                    palette: 'blue'
                  }
                  numberFormat: {
                    unit: 17
                    options: {
                      style: 'decimal'
                      maximumFractionDigits: 0
                    }
                  }
                }
              }
            }
            customWidth: '25'
            name: 'kpi - private-clouds'
          }
          {
            type: 3
            content: {
              version: 'KqlItem/1.0'
              query: 'resources\r\n| where type =~ "microsoft.avs/privateclouds/clusters" or (type =~ "microsoft.avs/privateclouds" and id in ({AVSInstance}))\r\n| extend clusterSize = iff(type =~ "microsoft.avs/privateclouds", toint(properties.managementCluster.clusterSize), toint(properties.clusterSize))\r\n| summarize TotalHosts = sum(clusterSize)\r\n| project Label = "Hosts", Value = TotalHosts'
              size: 4
              title: 'Total Hosts'
              queryType: 1
              resourceType: 'microsoft.resourcegraph/resources'
              crossComponentResources: [
                '{Subscription}'
              ]
              visualization: 'tiles'
              tileSettings: {
                showBorder: false
                titleContent: {
                  columnMatch: 'Label'
                  formatter: 1
                }
                leftContent: {
                  columnMatch: 'Value'
                  formatter: 12
                  formatOptions: {
                    palette: 'green'
                  }
                  numberFormat: {
                    unit: 17
                    options: {
                      style: 'decimal'
                      maximumFractionDigits: 0
                    }
                  }
                }
              }
            }
            customWidth: '25'
            name: 'kpi - total-hosts'
          }
          {
            type: 3
            content: {
              version: 'KqlItem/1.0'
              query: 'resources\r\n| where type =~ "microsoft.avs/privateclouds/clusters" or (type =~ "microsoft.avs/privateclouds" and id in ({AVSInstance}))\r\n| count\r\n| project Label = "Clusters", Value = Count'
              size: 4
              title: 'Total Clusters'
              queryType: 1
              resourceType: 'microsoft.resourcegraph/resources'
              crossComponentResources: [
                '{Subscription}'
              ]
              visualization: 'tiles'
              tileSettings: {
                showBorder: false
                titleContent: {
                  columnMatch: 'Label'
                  formatter: 1
                }
                leftContent: {
                  columnMatch: 'Value'
                  formatter: 12
                  formatOptions: {
                    palette: 'purple'
                  }
                  numberFormat: {
                    unit: 17
                    options: {
                      style: 'decimal'
                      maximumFractionDigits: 0
                    }
                  }
                }
              }
            }
            customWidth: '25'
            name: 'kpi - total-clusters'
          }
          {
            type: 3
            content: {
              version: 'KqlItem/1.0'
              query: 'alertsmanagementresources\r\n| where type =~ "microsoft.alertsmanagement/alerts"\r\n| where properties.essentials.targetResourceType =~ "microsoft.avs/privateclouds"\r\n| where properties.essentials.alertState in~ ("New", "Acknowledged")\r\n| count\r\n| project Label = "Active Alerts", Value = Count'
              size: 4
              title: 'Active Alerts'
              queryType: 1
              resourceType: 'microsoft.resourcegraph/resources'
              crossComponentResources: [
                '{Subscription}'
              ]
              visualization: 'tiles'
              tileSettings: {
                showBorder: false
                titleContent: {
                  columnMatch: 'Label'
                  formatter: 1
                }
                leftContent: {
                  columnMatch: 'Value'
                  formatter: 12
                  formatOptions: {
                    palette: 'redBright'
                  }
                  numberFormat: {
                    unit: 17
                    options: {
                      style: 'decimal'
                      maximumFractionDigits: 0
                    }
                  }
                }
              }
            }
            customWidth: '25'
            name: 'kpi - active-alerts'
          }
          {
            type: 3
            content: {
              version: 'KqlItem/1.0'
              query: 'resources\r\n| where type =~ "microsoft.avs/privateclouds"\r\n| where id in ({AVSInstance})\r\n| extend provisioningState = tostring(properties.provisioningState)\r\n| extend internet = tostring(properties.internet)\r\n| extend availability = tostring(properties.availability.strategy)\r\n| extend skuName = tostring(sku.name)\r\n| extend clusterSize = toint(properties.managementCluster.clusterSize)\r\n| extend circuitState = tostring(properties.circuit.expressRoutePrivatePeeringId)\r\n| extend hasCircuit = iff(isnotempty(circuitState), "Connected", "Not Connected")\r\n| project name, resourceGroup, location, provisioningState, skuName, clusterSize, internet, availability, hasCircuit'
              size: 0
              title: 'Private Cloud Health Status'
              noDataMessage: 'No AVS Private Cloud instances found in the selected subscription(s)'
              showExportToExcel: true
              queryType: 1
              resourceType: 'microsoft.resourcegraph/resources'
              crossComponentResources: [
                '{Subscription}'
              ]
              visualization: 'table'
              gridSettings: {
                formatters: [
                  {
                    columnMatch: 'provisioningState'
                    formatter: 18
                    formatOptions: {
                      thresholdsOptions: 'icons'
                      thresholdsGrid: [
                        {
                          operator: '=='
                          thresholdValue: 'Succeeded'
                          representation: 'success'
                          text: '{0}{1}'
                        }
                        {
                          operator: '=='
                          thresholdValue: 'Failed'
                          representation: '3'
                          text: '{0}{1}'
                        }
                        {
                          operator: '=='
                          thresholdValue: 'Updating'
                          representation: '2'
                          text: '{0}{1}'
                        }
                        {
                          operator: 'Default'
                          thresholdValue: null
                          representation: 'warning'
                          text: '{0}{1}'
                        }
                      ]
                    }
                  }
                  {
                    columnMatch: 'internet'
                    formatter: 18
                    formatOptions: {
                      thresholdsOptions: 'icons'
                      thresholdsGrid: [
                        {
                          operator: '=='
                          thresholdValue: 'Enabled'
                          representation: 'success'
                          text: '{0}{1}'
                        }
                        {
                          operator: 'Default'
                          thresholdValue: null
                          representation: 'disabled'
                          text: '{0}{1}'
                        }
                      ]
                    }
                  }
                  {
                    columnMatch: 'hasCircuit'
                    formatter: 18
                    formatOptions: {
                      thresholdsOptions: 'icons'
                      thresholdsGrid: [
                        {
                          operator: '=='
                          thresholdValue: 'Connected'
                          representation: 'success'
                          text: '{0}{1}'
                        }
                        {
                          operator: 'Default'
                          thresholdValue: null
                          representation: 'warning'
                          text: '{0}{1}'
                        }
                      ]
                    }
                  }
                  {
                    columnMatch: 'clusterSize'
                    formatter: 4
                    formatOptions: {
                      palette: 'blue'
                    }
                  }
                ]
                filter: true
                labelSettings: [
                  {
                    columnId: 'name'
                    label: 'Private Cloud'
                  }
                  {
                    columnId: 'resourceGroup'
                    label: 'Resource Group'
                  }
                  {
                    columnId: 'location'
                    label: 'Location'
                  }
                  {
                    columnId: 'provisioningState'
                    label: 'Status'
                  }
                  {
                    columnId: 'skuName'
                    label: 'SKU'
                  }
                  {
                    columnId: 'clusterSize'
                    label: 'Hosts'
                  }
                  {
                    columnId: 'internet'
                    label: 'Internet'
                  }
                  {
                    columnId: 'availability'
                    label: 'Availability'
                  }
                  {
                    columnId: 'hasCircuit'
                    label: 'ExpressRoute'
                  }
                ]
              }
            }
            name: 'query - health-status'
          }
          {
            type: 3
            content: {
              version: 'KqlItem/1.0'
              query: 'AzureMetrics\r\n| where ResourceProvider == "MICROSOFT.AVS"\r\n| where MetricName == "CpuUsageAverage"\r\n| where _ResourceId in~ ({AVSInstance})\r\n| summarize UsedPct = round(avg(Average), 1)\r\n| extend FreePct = round(100 - UsedPct, 1)\r\n| project UsedPct, FreePct\r\n| evaluate narrow()\r\n| extend Category = case(Column == "UsedPct", "CPU Used %", "CPU Available %")\r\n| project Category, Value = todecimal(Value)'
              size: 4
              title: 'Avg CPU Utilization'
              noDataMessage: 'No CPU metrics available - ensure diagnostic settings send metrics to Log Analytics'
              queryType: 0
              resourceType: 'microsoft.operationalinsights/workspaces'
              crossComponentResources: [
                '{Workspace}'
              ]
              visualization: 'piechart'
              chartSettings: {
                seriesLabelSettings: [
                  {
                    seriesName: 'CPU Used %'
                    color: 'orange'
                  }
                  {
                    seriesName: 'CPU Available %'
                    color: 'green'
                  }
                ]
              }
            }
            customWidth: '33'
            name: 'pie - cpu-utilization'
          }
          {
            type: 3
            content: {
              version: 'KqlItem/1.0'
              query: 'AzureMetrics\r\n| where ResourceProvider == "MICROSOFT.AVS"\r\n| where MetricName == "MemUsageAverage"\r\n| where _ResourceId in~ ({AVSInstance})\r\n| summarize UsedPct = round(avg(Average), 1)\r\n| extend FreePct = round(100 - UsedPct, 1)\r\n| project UsedPct, FreePct\r\n| evaluate narrow()\r\n| extend Category = case(Column == "UsedPct", "Memory Used %", "Memory Available %")\r\n| project Category, Value = todecimal(Value)'
              size: 4
              title: 'Avg Memory Utilization'
              noDataMessage: 'No Memory metrics available - ensure diagnostic settings send metrics to Log Analytics'
              queryType: 0
              resourceType: 'microsoft.operationalinsights/workspaces'
              crossComponentResources: [
                '{Workspace}'
              ]
              visualization: 'piechart'
              chartSettings: {
                seriesLabelSettings: [
                  {
                    seriesName: 'Memory Used %'
                    color: 'orange'
                  }
                  {
                    seriesName: 'Memory Available %'
                    color: 'green'
                  }
                ]
              }
            }
            customWidth: '33'
            name: 'pie - memory-utilization'
          }
          {
            type: 3
            content: {
              version: 'KqlItem/1.0'
              query: 'AzureMetrics\r\n| where ResourceProvider == "MICROSOFT.AVS"\r\n| where MetricName in ("DiskUsedLatest", "DiskCapacityLatest")\r\n| where TimeGenerated {TimeRange}\r\n| summarize Value = max(Maximum) by MetricName\r\n| extend UsedGB = iif(MetricName == "DiskUsedLatest", Value, 0.0)\r\n| extend CapacityGB = iif(MetricName == "DiskCapacityLatest", Value, 0.0)\r\n| summarize UsedGB = sum(UsedGB), CapacityGB = sum(CapacityGB)\r\n| extend FreeGB = round(CapacityGB - UsedGB, 1)\r\n| extend UsedGB = round(UsedGB, 1)\r\n| project-away CapacityGB\r\n| evaluate narrow()\r\n| extend Category = case(Column == "UsedGB", "Used (TB)", Column == "FreeGB", "Free (TB)", Column)\r\n| project Category, Value = todecimal(Value)'
              size: 4
              title: 'vSAN Disk Used vs Free (TB)'
              noDataMessage: 'No Storage metrics available - ensure diagnostic settings send metrics to Log Analytics'
              timeContextFromParameter: 'TimeRange'
              queryType: 0
              resourceType: 'microsoft.operationalinsights/workspaces'
              crossComponentResources: [
                '{Workspace}'
              ]
              visualization: 'piechart'
              chartSettings: {
                seriesLabelSettings: [
                  {
                    seriesName: 'Used (TB)'
                    color: 'orange'
                  }
                  {
                    seriesName: 'Free (TB)'
                    color: 'green'
                  }
                ]
              }
            }
            customWidth: '33'
            name: 'pie - vsan-storage'
          }
          {
            type: 10
            content: {
              chartId: 'overview-cpu-trend'
              version: 'MetricsItem/2.0'
              size: 0
              chartType: 2
              resourceType: 'Microsoft.AVS/privateClouds'
              metricScope: 0
              resourceParameter: 'AVSInstance'
              resourceIds: [
                '{AVSInstance}'
              ]
              timeContextFromParameter: 'TimeRange'
              timeContext: {
                durationMs: 604800000
              }
              metrics: [
                {
                  namespace: 'microsoft.avs/privateclouds'
                  metric: 'microsoft.avs/privateclouds--CpuUsageAverage'
                  aggregation: 4
                  splitBy: 'clustername'
                }
              ]
              title: 'CPU Utilization Trend by Cluster'
              showRefreshButton: true
              gridSettings: {
                rowLimit: 10000
              }
            }
            customWidth: '50'
            name: 'metric - overview-cpu-trend'
          }
          {
            type: 10
            content: {
              chartId: 'overview-mem-trend'
              version: 'MetricsItem/2.0'
              size: 0
              chartType: 2
              resourceType: 'Microsoft.AVS/privateClouds'
              metricScope: 0
              resourceParameter: 'AVSInstance'
              resourceIds: [
                '{AVSInstance}'
              ]
              timeContextFromParameter: 'TimeRange'
              timeContext: {
                durationMs: 604800000
              }
              metrics: [
                {
                  namespace: 'microsoft.avs/privateclouds'
                  metric: 'microsoft.avs/privateclouds--MemUsageAverage'
                  aggregation: 4
                  splitBy: 'clustername'
                }
              ]
              title: 'Memory Utilization Trend by Cluster'
              showRefreshButton: true
              gridSettings: {
                rowLimit: 10000
              }
            }
            customWidth: '50'
            name: 'metric - overview-mem-trend'
          }
          {
            type: 3
            content: {
              version: 'KqlItem/1.0'
              query: 'alertsmanagementresources\r\n| where type =~ "microsoft.alertsmanagement/alerts"\r\n| where properties.essentials.targetResourceType =~ "microsoft.avs/privateclouds"\r\n| where properties.essentials.alertState in~ ("New", "Acknowledged")\r\n| extend severity = tostring(properties.essentials.severity)\r\n| extend alertName = tostring(properties.essentials.alertRule)\r\n| extend firedTime = todatetime(properties.essentials.startDateTime)\r\n| extend targetResource = tostring(properties.essentials.targetResourceName)\r\n| extend alertState = tostring(properties.essentials.alertState)\r\n| project firedTime, severity, alertName, targetResource, alertState\r\n| order by firedTime desc\r\n| take 10'
              size: 0
              title: 'Recent Alerts'
              noDataMessage: 'No active alerts for AVS resources - all clear!'
              showExportToExcel: true
              queryType: 1
              resourceType: 'microsoft.resourcegraph/resources'
              crossComponentResources: [
                '{Subscription}'
              ]
              visualization: 'table'
              gridSettings: {
                formatters: [
                  {
                    columnMatch: 'severity'
                    formatter: 18
                    formatOptions: {
                      thresholdsOptions: 'icons'
                      thresholdsGrid: [
                        {
                          operator: '=='
                          thresholdValue: 'Sev0'
                          representation: '4'
                          text: 'Critical'
                        }
                        {
                          operator: '=='
                          thresholdValue: 'Sev1'
                          representation: '3'
                          text: 'Error'
                        }
                        {
                          operator: '=='
                          thresholdValue: 'Sev2'
                          representation: '2'
                          text: 'Warning'
                        }
                        {
                          operator: '=='
                          thresholdValue: 'Sev3'
                          representation: '1'
                          text: 'Info'
                        }
                        {
                          operator: 'Default'
                          thresholdValue: null
                          representation: 'unknown'
                          text: '{0}{1}'
                        }
                      ]
                    }
                  }
                  {
                    columnMatch: 'firedTime'
                    formatter: 6
                  }
                  {
                    columnMatch: 'alertState'
                    formatter: 18
                    formatOptions: {
                      thresholdsOptions: 'icons'
                      thresholdsGrid: [
                        {
                          operator: '=='
                          thresholdValue: 'New'
                          representation: 'Fired'
                          text: '{0}{1}'
                        }
                        {
                          operator: '=='
                          thresholdValue: 'Acknowledged'
                          representation: '2'
                          text: '{0}{1}'
                        }
                        {
                          operator: 'Default'
                          thresholdValue: null
                          representation: 'success'
                          text: '{0}{1}'
                        }
                      ]
                    }
                  }
                ]
                filter: true
                labelSettings: [
                  {
                    columnId: 'firedTime'
                    label: 'Fired Time'
                  }
                  {
                    columnId: 'severity'
                    label: 'Severity'
                  }
                  {
                    columnId: 'alertName'
                    label: 'Alert Rule'
                  }
                  {
                    columnId: 'targetResource'
                    label: 'Target Resource'
                  }
                  {
                    columnId: 'alertState'
                    label: 'State'
                  }
                ]
              }
            }
            name: 'query - recent-alerts'
          }
        ]
      }
      conditionalVisibility: {
        parameterName: 'Tab'
        comparison: 'isEqualTo'
        value: 'Overview'
      }
      name: 'Group - Summary'
    }
    {
      type: 12
      content: {
        version: 'NotebookGroup/1.0'
        groupType: 'editable'
        items: [
          {
            type: 3
            content: {
              version: 'KqlItem/1.0'
              query: 'resources\r\n| where type contains "microsoft.connectedvmwarevsphere" and type !contains "virtualmachines" and type !contains "microsoft.connectedvmwarevsphere/virtualnetworks" and type !contains "microsoft.connectedvmwarevsphere/virtualmachinetemplates"\r\n| extend resource = tolower(tostring(split(type, "/")[1]))\r\n| summarize count(resource) by resource'
              size: 4
              noDataMessage: 'No Arc-enabled VMware vSphere resources found in the selected subscription'
              exportFieldName: 'resource'
              exportParameterName: 'R'
              queryType: 1
              resourceType: 'microsoft.resourcegraph/resources'
              crossComponentResources: [
                '{Subscription}'
              ]
              visualization: 'tiles'
              tileSettings: {
                showBorder: false
                titleContent: {
                  columnMatch: 'resource'
                  formatter: 1
                }
                leftContent: {
                  columnMatch: 'count_resource'
                  formatter: 12
                  formatOptions: {
                    palette: 'auto'
                  }
                  numberFormat: {
                    unit: 17
                    options: {
                      maximumSignificantDigits: 3
                      maximumFractionDigits: 2
                    }
                  }
                }
              }
            }
            name: 'query - 0'
          }
          {
            type: 3
            content: {
              version: 'KqlItem/1.0'
              query: 'resources\r\n| where type contains "microsoft.connectedvmwarevsphere" and type !contains "virtualmachines" and type !contains "microsoft.connectedvmwarevsphere/virtualnetworks" and type !contains "microsoft.connectedvmwarevsphere/virtualmachinetemplates"\r\n| extend resource = tolower(tostring(split(type, "/")[1]))\r\n| extend Tag = iff(notempty(tags),tags,"No Tags")\r\n//| extend RGID = strcat({Subscription},"/resourceGroups/",resourceGroup)\r\n| project id,resource,  resourceGroup, Tag//, RGID\r\n| order by resource'
              size: 0
              title: 'All Resources'
              noDataMessage: 'No Arc-enabled VMware vSphere resources found - Enable Azure Arc for VMware vSphere to see resources here'
              showRefreshButton: true
              showExportToExcel: true
              queryType: 1
              resourceType: 'microsoft.resourcegraph/resources'
              crossComponentResources: [
                '{Subscription}'
              ]
              visualization: 'table'
              gridSettings: {
                formatters: [
                  {
                    columnMatch: 'resourceGroup'
                    formatter: 13
                    formatOptions: {
                      linkTarget: 'Resource'
                      showIcon: true
                    }
                  }
                  {
                    columnMatch: 'RGID'
                    formatter: 14
                    formatOptions: {
                      linkTarget: null
                      showIcon: true
                    }
                  }
                ]
                filter: true
                labelSettings: [
                  {
                    columnId: 'id'
                    label: 'Name'
                  }
                  {
                    columnId: 'resource'
                    label: 'Resource'
                  }
                  {
                    columnId: 'resourceGroup'
                    label: 'Resource Group'
                  }
                  {
                    columnId: 'Tag'
                    label: 'Tags'
                  }
                ]
              }
            }
            conditionalVisibility: {
              parameterName: 'R'
              comparison: 'isEqualTo'
            }
            name: 'query - 1'
          }
          {
            type: 3
            content: {
              version: 'KqlItem/1.0'
              query: 'resources\r\n| where type contains "microsoft.connectedvmwarevsphere" and type !contains "virtualmachines" and type !contains "microsoft.connectedvmwarevsphere/virtualnetworks" and type !contains "microsoft.connectedvmwarevsphere/virtualmachinetemplates"\r\n| extend resource = tolower(tostring(split(type, "/")[1]))\r\n| extend Tag = iff(notempty(tags),tags,"No Tags")\r\n| where resource == "{R}"\r\n| project id,resource,  resourceGroup, Tag\r\n| order by resource'
              size: 0
              title: '{R}'
              noDataMessage: 'No resources found for the selected resource type'
              showRefreshButton: true
              showExportToExcel: true
              queryType: 1
              resourceType: 'microsoft.resourcegraph/resources'
              crossComponentResources: [
                '{Subscription}'
              ]
              gridSettings: {
                filter: true
              }
            }
            conditionalVisibility: {
              parameterName: 'R'
              comparison: 'isNotEqualTo'
            }
            name: 'query - 2'
          }
        ]
      }
      conditionalVisibility: {
        parameterName: 'Tab'
        comparison: 'isEqualTo'
        value: 'Resources'
      }
      name: 'Group - AVS Resources'
    }
    {
      type: 12
      content: {
        version: 'NotebookGroup/1.0'
        groupType: 'editable'
        items: [
          {
            type: 9
            content: {
              version: 'KqlParameterItem/1.0'
              crossComponentResources: [
                '{Subscription}'
              ]
              parameters: [
                {
                  id: '0d65bc28-3879-4da7-a1f7-792b5e882fd9'
                  version: 'KqlParameterItem/1.0'
                  name: 'LatestToolsVer'
                  type: 2
                  isRequired: true
                  query: 'resources\r\n| where type ==  "microsoft.connectedvmwarevsphere/virtualmachines" \r\n| extend toolsVersion = toint(properties.osProfile.toolsVersion)\r\n| project toolsVersion\r\n| order by toolsVersion desc\r\n| top 1 by toolsVersion'
                  crossComponentResources: [
                    '{Subscription}'
                  ]
                  isHiddenWhenLocked: true
                  typeSettings: {
                    additionalResourceOptions: [
                      'value::1'
                    ]
                    showDefault: false
                  }
                  timeContext: {
                    durationMs: 86400000
                  }
                  queryType: 1
                  resourceType: 'microsoft.resourcegraph/resources'
                  value: 'value::1'
                }
                {
                  id: 'b0eb1c08-84d5-44a0-8fa0-95f0ab91a37c'
                  version: 'KqlParameterItem/1.0'
                  name: 'vCenter'
                  type: 2
                  isRequired: true
                  multiSelect: true
                  quote: '\''
                  delimiter: ','
                  query: 'resources\r\n| where type ==  "microsoft.connectedvmwarevsphere/virtualmachines" \r\n| extend VSID = tolower(tostring(split(properties.vCenterId, "/")[8]))\r\n| project VSID'
                  crossComponentResources: [
                    '{Subscription}'
                  ]
                  typeSettings: {
                    additionalResourceOptions: [
                      'value::1'
                      'value::all'
                    ]
                    showDefault: false
                  }
                  queryType: 1
                  resourceType: 'microsoft.resourcegraph/resources'
                  value: [
                    'value::all'
                  ]
                }
              ]
              style: 'pills'
              queryType: 1
              resourceType: 'microsoft.resourcegraph/resources'
            }
            name: 'parameters - 1'
          }
          {
            type: 3
            content: {
              version: 'KqlItem/1.0'
              query: 'resources\r\n| where type ==  "microsoft.connectedvmwarevsphere/virtualmachines" \r\n| extend VSID = tolower(tostring(split(properties.vCenterId, "/")[8]))\r\n| where VSID in ({vCenter})\r\n| extend OS = properties.osProfile\r\n| extend computerName = properties.osProfile.computerName\r\n| extend osType = properties.osProfile.osType\r\n| extend osName = properties.osProfile.osName\r\n| extend toolsRunningStatus = properties.osProfile.toolsRunningStatus\r\n| extend toolsVersion = toint(properties.osProfile.toolsVersion)\r\n| extend cores = properties.hardwareProfile.numCoresPerSocket\r\n| extend mem = properties.hardwareProfile.memorySizeMB\r\n| extend CPUs = properties.hardwareProfile.numCPUs\r\n| extend Power =  properties.powerState\r\n| project id, VSID, osType, osName,CPUs, cores, mem, Power,toolsRunningStatus, toolsVersion'
              size: 0
              noDataMessage: 'No VMware virtual machines found for the selected vCenter - Ensure Azure Arc for VMware vSphere is enabled'
              showRefreshButton: true
              showExportToExcel: true
              queryType: 1
              resourceType: 'microsoft.resourcegraph/resources'
              crossComponentResources: [
                '{Subscription}'
              ]
              visualization: 'table'
              gridSettings: {
                formatters: [
                  {
                    columnMatch: 'VSID'
                    formatter: 0
                    formatOptions: {
                      customColumnWidthSetting: '20.2857ch'
                    }
                  }
                  {
                    columnMatch: 'osType'
                    formatter: 18
                    formatOptions: {
                      thresholdsOptions: 'colors'
                      thresholdsGrid: [
                        {
                          operator: '=='
                          thresholdValue: 'Windows'
                          representation: 'lightBlue'
                          text: '{0}{1}'
                        }
                        {
                          operator: '=='
                          thresholdValue: 'Linux'
                          representation: 'green'
                          text: '{0}{1}'
                        }
                        {
                          operator: 'Default'
                          thresholdValue: null
                          representation: 'gray'
                          text: 'Unknown'
                        }
                      ]
                    }
                  }
                  {
                    columnMatch: 'osName'
                    formatter: 1
                    formatOptions: {
                      customColumnWidthSetting: '29.1429ch'
                    }
                  }
                  {
                    columnMatch: 'CPUs'
                    formatter: 1
                  }
                  {
                    columnMatch: 'cores'
                    formatter: 1
                  }
                  {
                    columnMatch: 'mem'
                    formatter: 1
                  }
                  {
                    columnMatch: 'Power'
                    formatter: 18
                    formatOptions: {
                      thresholdsOptions: 'icons'
                      thresholdsGrid: [
                        {
                          operator: '=='
                          thresholdValue: 'poweredOn'
                          representation: 'success'
                          text: ''
                        }
                        {
                          operator: 'Default'
                          thresholdValue: null
                          representation: 'Unavailable'
                          text: ''
                        }
                      ]
                    }
                  }
                  {
                    columnMatch: 'toolsRunningStatus'
                    formatter: 18
                    formatOptions: {
                      thresholdsOptions: 'icons'
                      thresholdsGrid: [
                        {
                          operator: '=='
                          thresholdValue: 'guestToolsRunning'
                          representation: 'success'
                          text: ''
                        }
                        {
                          operator: 'Default'
                          thresholdValue: null
                          representation: '4'
                          text: ''
                        }
                      ]
                    }
                  }
                  {
                    columnMatch: 'Powered On'
                    formatter: 18
                    formatOptions: {
                      thresholdsOptions: 'icons'
                      thresholdsGrid: [
                        {
                          operator: '=='
                          thresholdValue: 'poweredOn'
                          representation: 'success'
                          text: ''
                        }
                        {
                          operator: 'Default'
                          thresholdValue: null
                          representation: 'info'
                          text: ''
                        }
                      ]
                    }
                  }
                ]
                filter: true
                labelSettings: [
                  {
                    columnId: 'id'
                    label: 'VM'
                  }
                  {
                    columnId: 'VSID'
                    label: 'vCenter'
                  }
                  {
                    columnId: 'osType'
                    label: 'OS'
                  }
                  {
                    columnId: 'osName'
                    label: 'OS Version'
                  }
                  {
                    columnId: 'CPUs'
                    label: 'CPUs'
                  }
                  {
                    columnId: 'cores'
                    label: 'Cores'
                  }
                  {
                    columnId: 'mem'
                    label: 'Memory'
                  }
                  {
                    columnId: 'Power'
                    label: 'Powered On'
                  }
                  {
                    columnId: 'toolsRunningStatus'
                    label: 'Guest Managed'
                  }
                  {
                    columnId: 'toolsVersion'
                    label: 'Tools Version'
                  }
                ]
              }
            }
            name: 'query - 0'
          }
        ]
      }
      conditionalVisibility: {
        parameterName: 'Tab'
        comparison: 'isEqualTo'
        value: 'Resources'
      }
      name: 'Group - AVS Virtual Machines'
    }
    {
      type: 12
      content: {
        version: 'NotebookGroup/1.0'
        groupType: 'editable'
        items: [
          {
            type: 9
            content: {
              version: 'KqlParameterItem/1.0'
              crossComponentResources: [
                '{Workspace}'
              ]
              parameters: [
                {
                  id: '9db8b056-5686-409d-a589-9ae87eed9cee'
                  version: 'KqlParameterItem/1.0'
                  name: 'ShowHelp'
                  label: 'Show Alert Help'
                  type: 10
                  isRequired: true
                  typeSettings: {
                    additionalResourceOptions: []
                    showDefault: false
                  }
                  jsonData: '[\r\n { "value": "Yes", "label": "Yes"},\r\n { "value": "No", "label": "No", "selected":true }\r\n]'
                  timeContext: {
                    durationMs: 0
                  }
                  timeContextFromParameter: 'TimeRange'
                }
              ]
              style: 'pills'
              queryType: 0
              resourceType: 'microsoft.operationalinsights/workspaces'
            }
            name: 'parameters - 5'
          }
          {
            type: 1
            content: {
              json: 'In order to deploy alerts you will need the resource ID for the AVS instance you want to be alerted on. Alerts will also need to be deployed for each seperate AVS instance.\r\n\r\nTo get the resource ID, navigate to the Overview blade of the required AVS instance and click on **"JSON View"** in the top right corner. The ID will be at the top of the fly out menu and looks as follow:\r\n\r\n**Example:** /subscriptions/"subscription ID"/resourceGroups/"Resource Group"/providers/Microsoft.AVS/privateClouds/"AVS instance name"'
            }
            conditionalVisibility: {
              parameterName: 'ShowHelp'
              comparison: 'isEqualTo'
              value: 'Yes'
            }
            name: 'text - 4'
          }
          {
            type: 11
            content: {
              version: 'LinkItem/1.0'
              style: 'nav'
              links: [
                {
                  id: '11763710-bc13-4652-85c8-e2fa66a62c0a'
                  cellValue: 'https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FEnterprise-Scale-for-AVS%2Fmain%2FBrownField%2FMonitoring%2FAVS-Utilization-Alerts%2FARM%2FAVSMonitor.deploy.json'
                  linkTarget: 'Url'
                  linkLabel: 'Deploy Metric Alerts'
                  style: 'link'
                }
                {
                  id: '93c23f27-38e9-429c-a1fb-3c24fa4b17fd'
                  cellValue: 'https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FEnterprise-Scale-for-AVS%2Fmain%2FBrownField%2FMonitoring%2FAVS-Service-Health%2FARM%2FAVSServiceHealth.deploy.json'
                  linkTarget: 'Url'
                  linkLabel: 'Deploy Service Health Alerts'
                  style: 'link'
                }
              ]
            }
            name: 'links - 6'
          }
          {
            type: 3
            content: {
              version: 'KqlItem/1.0'
              query: 'alertsmanagementresources\r\n| extend FireTime = todatetime(properties.essentials.startDateTime), \r\n         Severity = tostring(properties.essentials.severity), \r\n         MonitorCondition = tostring(properties.essentials.monitorCondition), \r\n         AlertTarget = tostring(properties.essentials.targetResourceType), \r\n         MonitorService = tostring(properties.essentials.monitorService)\r\n| where FireTime {TimeRange}\r\n| extend AlertTarget = case(\r\n        MonitorService == \'ActivityLog Administrative\', \'ActivityLog\',\r\n        AlertTarget == \'microsoft.insights/components\', \'App Insights\',\r\n        AlertTarget == \'microsoft.operationalinsights/workspaces\', \'Log Analytics\', \r\n        AlertTarget)\r\n| extend Total = "TotalAlerts"\r\n| where (id contains "microsoft.connectedvmwarevsphere") or (id contains "microsoft.avs/privatecloud")\r\n| summarize TotalAlerts= count(MonitorCondition) by Total'
              size: 4
              title: 'Alert Summary'
              noDataMessage: '0 alerts - AVS healthy'
              queryType: 1
              resourceType: 'microsoft.resourcegraph/resources'
              crossComponentResources: [
                '{Subscription}'
              ]
              visualization: 'tiles'
              tileSettings: {
                showBorder: true
                titleContent: {
                  columnMatch: 'Total'
                  formatter: 18
                  formatOptions: {
                    thresholdsOptions: 'icons'
                    thresholdsGrid: [
                      {
                        operator: 'Default'
                        thresholdValue: null
                        representation: 'Sev4'
                        text: '{0}{1}'
                      }
                    ]
                  }
                }
                leftContent: {
                  columnMatch: 'TotalAlerts'
                  formatter: 12
                  formatOptions: {
                    palette: 'none'
                  }
                  numberFormat: {
                    unit: 17
                    options: {
                      maximumSignificantDigits: 3
                      maximumFractionDigits: 2
                    }
                  }
                }
              }
            }
            customWidth: '25'
            name: 'query - 1'
          }
          {
            type: 3
            content: {
              version: 'KqlItem/1.0'
              query: 'alertsmanagementresources\r\n| where (id contains "microsoft.connectedvmwarevsphere") or (id contains "microsoft.avs/privatecloud")\r\n| extend FireTime = todatetime(properties.essentials.startDateTime), Severity = tostring(properties.essentials.severity)\r\n| where FireTime {TimeRange}\r\n| summarize Count = count() by Severity\r\n| extend Label = case(Severity == "Sev0", "Critical", Severity == "Sev1", "Error", Severity == "Sev2", "Warning", Severity == "Sev3", "Informational", Severity == "Sev4", "Verbose", Severity)\r\n| extend SortOrder = case(Severity == "Sev0", 0, Severity == "Sev1", 1, Severity == "Sev2", 2, Severity == "Sev3", 3, Severity == "Sev4", 4, 5)\r\n| sort by SortOrder asc\r\n| project Label, Count'
              size: 4
              title: 'Severity Summary'
              noDataMessage: 'No alerts - AVS environment is healthy ✓'
              queryType: 1
              resourceType: 'microsoft.resourcegraph/resources'
              crossComponentResources: [
                '{Subscription}'
              ]
              visualization: 'tiles'
              sortBy: []
              tileSettings: {
                showBorder: true
                titleContent: {
                  columnMatch: 'Label'
                  formatter: 18
                  formatOptions: {
                    thresholdsOptions: 'icons'
                    thresholdsGrid: [
                      {
                        operator: 'contains'
                        thresholdValue: 'Critical'
                        representation: 'Sev0'
                        text: '{0}{1}'
                      }
                      {
                        operator: 'contains'
                        thresholdValue: 'Error'
                        representation: 'Sev1'
                        text: '{0}{1}'
                      }
                      {
                        operator: 'contains'
                        thresholdValue: 'Warning'
                        representation: 'Sev2'
                        text: '{0}{1}'
                      }
                      {
                        operator: 'contains'
                        thresholdValue: 'Informational'
                        representation: 'Sev3'
                        text: '{0}{1}'
                      }
                      {
                        operator: 'contains'
                        thresholdValue: 'Verbose'
                        representation: 'unknown'
                        text: '{0}{1}'
                      }
                      {
                        operator: 'Default'
                        thresholdValue: null
                        representation: 'unknown'
                        text: '{0}{1}'
                      }
                    ]
                  }
                }
                leftContent: {
                  columnMatch: 'Count'
                  formatter: 12
                  formatOptions: {
                    palette: 'none'
                  }
                  numberFormat: {
                    unit: 17
                    options: {
                      maximumSignificantDigits: 3
                      maximumFractionDigits: 2
                    }
                  }
                }
              }
            }
            customWidth: '75'
            name: 'query - severity-summary'
          }
          {
            type: 3
            content: {
              version: 'KqlItem/1.0'
              query: 'alertsmanagementresources\r\n| where (id contains "microsoft.connectedvmwarevsphere") or (id contains "microsoft.avs/privatecloud")\r\n| extend FireTime = todatetime(properties.essentials.startDateTime), \r\n         LastModifiedTime = todatetime(properties.essentials.lastModifiedDateTime),\r\n         Severity = tostring(properties.essentials.severity), \r\n         MonitorCondition = tostring(properties.essentials.monitorCondition), \r\n         AlertTarget = tostring(properties.essentials.targetResourceType), \r\n         MonitorService = tostring(properties.essentials.monitorService),\r\n         ResolvedTime = todatetime(properties.essentials.monitorConditionResolvedDateTime)\r\n| where FireTime {TimeRange}\r\n| extend AlertTarget = case(\r\n                MonitorService == \'ActivityLog Administrative\', \'ActivityLog\',\r\n                AlertTarget == \'microsoft.insights/components\', \'App Insights\',\r\n                AlertTarget == \'microsoft.operationalinsights/workspaces\', \'Log Analytics\', \r\n                AlertTarget)          \r\n| mv-expand Condition = properties.context.context.condition.allOf\r\n| extend SignalLogic = case(\r\n                MonitorService == "VM Insights - Health", strcat("VM Health for ", properties.essentials.targetResourceName, " Changed from ", properties.context.monitorStateBeforeAlertCreated, " to ", properties.context.monitorStateWhenAlertCreated),\r\n                AlertTarget == "ActivityLog", strcat("When the Activity Log has Category = ", properties.context.context.activityLog.properties.eventCategory, " and Signal name = ", properties.context.context.activityLog.properties.message),\r\n                MonitorService == "Smart Detector", strcat(properties.SmartDetectorName, " Detected failure rate of ", properties.DetectedFailureRate, " above normal failure rate of ", properties.context.NormalFailureRate),\r\n                MonitorService == "Log Analytics", strcat("Alert when ", properties.context.AlertType, " is ", properties.context.AlertThresholdOperator, " threshold ", properties.context.AlertThresholdValue),\r\n                MonitorService == "ActivityLog Autoscale", strcat(properties.context.context.activityLog.operationName, " from ", properties.context.context.activityLog.properties.oldInstancesCount, " to ", properties.context.context.activityLog.properties.newInstancesCount),\r\n                strcat("Alert when metric ", Condition.metricName, Condition.timeAggregation, " is ", Condition.operator, " threshold ", Condition.threshold)),\r\n         Query = case(\r\n                 MonitorService == "Log Alerts V2", tostring(Condition.searchQuery),\r\n                 MonitorService == "Log Analytics", tostring(properties.context.SearchQuery), "N/A"),\r\n         MetricValue = iff(MonitorService == "Log Analytics", toint(properties.context.ResultCount), toint(Condition.metricValue)),\r\n         ResourceName = iff(AlertTarget == "ActivityLog", properties.context.context.activityLog.subscriptionId, tostring(properties.essentials.targetResourceName))\r\n| extend OpenTime = iff(MonitorCondition == "Resolved", datetime_diff(\'minute\', ResolvedTime, FireTime), datetime_diff(\'minute\', now(), FireTime)),\r\n         Details = pack_all()\r\n| project name, AlertTarget, id, subscriptionId, MonitorCondition, FireTime, LastModifiedTime, OpenTime, SignalLogic, Query, MetricValue, ResourceName, Details'
              size: 0
              showRefreshButton: true
              showExportToExcel: true
              noDataMessage: 'No alerts found in the selected time range - AVS environment is healthy'
              queryType: 1
              resourceType: 'microsoft.resourcegraph/resources'
              crossComponentResources: [
                '{Subscription}'
              ]
              visualization: 'table'
              gridSettings: {
                formatters: [
                  {
                    columnMatch: '$gen_group'
                    formatter: 15
                    formatOptions: {
                      linkTarget: 'OpenBlade'
                      linkIsContextBlade: true
                      showIcon: true
                      bladeOpenContext: {
                        bladeName: 'AlertDetailsTemplateBlade'
                        extensionName: 'Microsoft_Azure_Monitoring'
                        bladeParameters: [
                          {
                            name: 'alertId'
                            source: 'column'
                            value: 'id'
                          }
                          {
                            name: 'alertName'
                            source: 'column'
                            value: 'name'
                          }
                          {
                            name: 'invokedFrom'
                            source: 'static'
                            value: 'Workbooks'
                          }
                        ]
                      }
                    }
                  }
                  {
                    columnMatch: 'name'
                    formatter: 5
                  }
                  {
                    columnMatch: 'id'
                    formatter: 5
                  }
                  {
                    columnMatch: 'MonitorCondition'
                    formatter: 18
                    formatOptions: {
                      thresholdsOptions: 'icons'
                      thresholdsGrid: [
                        {
                          operator: '=='
                          thresholdValue: 'Fired'
                          representation: '2'
                          text: '{0}{1}'
                        }
                        {
                          operator: '=='
                          thresholdValue: 'Resolved'
                          representation: 'success'
                          text: '{0}{1}'
                        }
                        {
                          operator: 'Default'
                          thresholdValue: null
                          representation: 'success'
                          text: '{0}{1}'
                        }
                      ]
                    }
                  }
                  {
                    columnMatch: 'FireTime'
                    formatter: 6
                  }
                  {
                    columnMatch: 'LastModifiedTime'
                    formatter: 6
                  }
                  {
                    columnMatch: 'OpenTime'
                    formatter: 8
                    formatOptions: {
                      palette: 'greenRed'
                    }
                  }
                ]
                filter: true
                hierarchySettings: {
                  treeType: 1
                  groupBy: [
                    'subscriptionId'
                  ]
                  expandTopLevel: true
                  finalBy: 'name'
                }
              }
            }
            name: 'query - 0'
          }
        ]
      }
      conditionalVisibility: {
        parameterName: 'Tab'
        comparison: 'isEqualTo'
        value: 'Operations'
      }
      name: 'Group - Alerts'
    }
    {
      type: 12
      content: {
        version: 'NotebookGroup/1.0'
        groupType: 'editable'
        items: [
          {
            type: 1
            content: {
              json: '### Azure Advisor recommendations for Azure VMware Solution'
            }
            name: 'text - 1'
          }
          {
            type: 9
            content: {
              version: 'KqlParameterItem/1.0'
              crossComponentResources: [
                '{Subscription}'
              ]
              parameters: [
                {
                  id: '88c663d7-da13-44da-a53f-15f8fdb1ca57'
                  version: 'KqlParameterItem/1.0'
                  name: 'Impact'
                  type: 2
                  multiSelect: true
                  quote: '\''
                  delimiter: ','
                  query: 'AdvisorResources\r\n| where type == \'microsoft.advisor/recommendations\'\r\n| extend imp = tostring(properties.impact)\r\n| distinct imp'
                  crossComponentResources: [
                    '{Subscription}'
                  ]
                  typeSettings: {
                    additionalResourceOptions: [
                      'value::all'
                    ]
                    showDefault: false
                  }
                  timeContext: {
                    durationMs: 86400000
                  }
                  queryType: 1
                  resourceType: 'microsoft.resourcegraph/resources'
                  value: [
                    'value::all'
                  ]
                }
              ]
              style: 'pills'
              queryType: 1
              resourceType: 'microsoft.resourcegraph/resources'
            }
            name: 'parameters - 2'
          }
          {
            type: 3
            content: {
              version: 'KqlItem/1.0'
              query: 'AdvisorResources\r\n| where type == \'microsoft.advisor/recommendations\'\r\n| where properties.impactedField contains "microsoft.avs" or tolower(tostring(properties.resourceMetadata)) contains "vmware"\r\n| extend SD = tostring(properties.shortDescription.solution)\r\n| extend cat = tostring(properties.category)\r\n| extend imp = tostring(properties.impact)\r\n| extend LU = tostring(properties.lastUpdated)\r\n| extend IR = tostring(properties.impactedValue)\r\n| where imp in ({Impact}) //or \'*\' in ({Impact})\r\n| project IR, resourceGroup, SD, cat, imp, LU,subscriptionId'
              size: 0
              showRefreshButton: true
              showExportToExcel: true
              noDataMessage: 'No Advisor recommendations for AVS resources'
              queryType: 1
              resourceType: 'microsoft.resourcegraph/resources'
              crossComponentResources: [
                '{Subscription}'
              ]
              visualization: 'table'
              gridSettings: {
                formatters: [
                  {
                    columnMatch: 'IR'
                    formatter: 13
                    formatOptions: {
                      linkTarget: 'GenericDetails'
                      linkIsContextBlade: true
                      showIcon: true
                    }
                  }
                  {
                    columnMatch: 'SD'
                    formatter: 7
                    formatOptions: {
                      linkTarget: 'CellDetails'
                      linkIsContextBlade: true
                    }
                  }
                  {
                    columnMatch: 'imp'
                    formatter: 18
                    formatOptions: {
                      thresholdsOptions: 'colors'
                      thresholdsGrid: [
                        {
                          operator: '=='
                          thresholdValue: 'High'
                          representation: 'redBright'
                          text: '{0}{1}'
                        }
                        {
                          operator: '=='
                          thresholdValue: 'Medium'
                          representation: 'yellow'
                          text: '{0}{1}'
                        }
                        {
                          operator: '=='
                          thresholdValue: 'Low'
                          representation: 'blue'
                          text: '{0}{1}'
                        }
                        {
                          operator: 'Default'
                          thresholdValue: null
                          representation: 'blue'
                          text: '{0}{1}'
                        }
                      ]
                    }
                  }
                  {
                    columnMatch: 'LU'
                    formatter: 6
                  }
                ]
                filter: true
                labelSettings: [
                  {
                    columnId: 'IR'
                    label: 'Resource'
                  }
                  {
                    columnId: 'resourceGroup'
                    label: 'RG'
                  }
                  {
                    columnId: 'SD'
                    label: 'Description'
                  }
                  {
                    columnId: 'cat'
                    label: 'Category'
                  }
                  {
                    columnId: 'imp'
                    label: 'Impact'
                  }
                  {
                    columnId: 'LU'
                    label: 'Last Updated'
                  }
                  {
                    columnId: 'subscriptionId'
                    label: 'Subscription'
                  }
                ]
              }
            }
            name: 'query - 0'
          }
        ]
      }
      conditionalVisibility: {
        parameterName: 'Tab'
        comparison: 'isEqualTo'
        value: 'Operations'
      }
      name: 'group - Advisor'
    }
    {
      type: 12
      content: {
        version: 'NotebookGroup/1.0'
        groupType: 'editable'
        items: [
          {
            type: 9
            content: {
              version: 'KqlParameterItem/1.0'
              crossComponentResources: [
                '{Workspace}'
              ]
              parameters: [
                {
                  id: '88593ed5-65af-436c-a72e-ea92df78cc42'
                  version: 'KqlParameterItem/1.0'
                  name: 'ShowHelpA'
                  label: 'Show Activity Help'
                  type: 10
                  isRequired: true
                  typeSettings: {
                    additionalResourceOptions: []
                    showDefault: false
                  }
                  jsonData: '[\r\n { "value": "Yes", "label": "Yes"},\r\n { "value": "No", "label": "No", "selected":true }\r\n]'
                  timeContext: {
                    durationMs: 1800000
                  }
                }
              ]
              style: 'pills'
              queryType: 0
              resourceType: 'microsoft.operationalinsights/workspaces'
            }
            name: 'parameters - 1'
          }
          {
            type: 1
            content: {
              json: '**In order for this section to display activity data first ensure that Azure activity log collection from your AVS Private Cloud to Log Analytics is enabled.**\r\n\r\nThis can be done from the Activity log blade of Azure Monitor.\r\n\r\nIf this is not enabled you may see the following message **"\'project\' operator: Failed to resolve scalar expression named \'message\'"**\r\n\r\n'
            }
            conditionalVisibility: {
              parameterName: 'ShowHelpA'
              comparison: 'isEqualTo'
              value: 'Yes'
            }
            name: 'text - 2'
          }
          {
            type: 3
            content: {
              version: 'KqlItem/1.0'
              query: 'AzureActivity \r\n| where ResourceProviderValue =="MICROSOFT.AVS"\r\n| extend prop = parse_json(Properties)\r\n| evaluate bag_unpack(prop)\r\n| project TimeGenerated, message, Level, ActivityStatusValue, Caller'
              size: 0
              showAnalytics: true
              title: 'AVS Activity'
              timeContextFromParameter: 'TimeRange'
              showExportToExcel: true
              queryType: 0
              resourceType: 'microsoft.operationalinsights/workspaces'
              crossComponentResources: [
                '{Workspace}'
              ]
              visualization: 'table'
              gridSettings: {
                filter: true
                sortBy: [
                  {
                    itemKey: 'TimeGenerated'
                    sortOrder: 1
                  }
                ]
              }
              sortBy: [
                {
                  itemKey: 'TimeGenerated'
                  sortOrder: 1
                }
              ]
            }
            name: 'query - 4'
          }
        ]
      }
      conditionalVisibility: {
        parameterName: 'Tab'
        comparison: 'isEqualTo'
        value: 'Operations'
      }
      name: 'group - Activity'
    }
    {
      type: 12
      content: {
        version: 'NotebookGroup/1.0'
        groupType: 'editable'
        items: [
          {
            type: 9
            content: {
              version: 'KqlParameterItem/1.0'
              crossComponentResources: [
                '{Workspace}'
              ]
              parameters: [
                {
                  id: '1a79bc93-b09a-4bb4-93d3-ea8c184736fa'
                  version: 'KqlParameterItem/1.0'
                  name: 'HostName'
                  type: 2
                  isRequired: true
                  multiSelect: true
                  quote: '\''
                  delimiter: ','
                  query: 'AVSSyslog \r\n| distinct HostName'
                  crossComponentResources: [
                    '{Workspace}'
                  ]
                  typeSettings: {
                    additionalResourceOptions: [
                      'value::all'
                    ]
                    showDefault: false
                  }
                  timeContext: {
                    durationMs: 0
                  }
                  timeContextFromParameter: 'TimeRange'
                  queryType: 0
                  resourceType: 'microsoft.operationalinsights/workspaces'
                  value: [
                    'value::all'
                  ]
                }
                {
                  id: 'd4044f39-295b-4158-adc7-e82afee13409'
                  version: 'KqlParameterItem/1.0'
                  name: 'AppName'
                  type: 2
                  isRequired: true
                  multiSelect: true
                  quote: '\''
                  delimiter: ','
                  query: 'AVSSyslog \r\n| distinct AppName'
                  crossComponentResources: [
                    '{Workspace}'
                  ]
                  typeSettings: {
                    additionalResourceOptions: [
                      'value::all'
                    ]
                    showDefault: false
                  }
                  timeContext: {
                    durationMs: 0
                  }
                  timeContextFromParameter: 'TimeRange'
                  queryType: 0
                  resourceType: 'microsoft.operationalinsights/workspaces'
                  value: [
                    'value::all'
                  ]
                }
                {
                  version: 'KqlParameterItem/1.0'
                  name: 'Severity'
                  type: 2
                  isRequired: true
                  multiSelect: true
                  quote: '\''
                  delimiter: ','
                  query: 'AVSSyslog \r\n| distinct Severity'
                  crossComponentResources: [
                    '{Workspace}'
                  ]
                  typeSettings: {
                    additionalResourceOptions: [
                      'value::all'
                    ]
                    showDefault: false
                  }
                  timeContext: {
                    durationMs: 0
                  }
                  timeContextFromParameter: 'TimeRange'
                  queryType: 0
                  resourceType: 'microsoft.operationalinsights/workspaces'
                  value: [
                    'value::all'
                  ]
                  id: '83f0c115-953b-42db-870c-b22344745fba'
                }
              ]
              style: 'pills'
              queryType: 0
              resourceType: 'microsoft.operationalinsights/workspaces'
            }
            name: 'parameters - 0'
          }
          {
            type: 3
            content: {
              version: 'KqlItem/1.0'
              query: 'AVSSyslog \r\n| where HostName in ({HostName})\r\n| where AppName in ({AppName})\r\n| where Severity in ({Severity}) or \'*\' in ({Severity})\r\n| summarize count() by Severity'
              size: 4
              title: 'Count of records by severity'
              timeContextFromParameter: 'TimeRange'
              exportFieldName: 'Severity'
              exportParameterName: 'Sev'
              queryType: 0
              resourceType: 'microsoft.operationalinsights/workspaces'
              crossComponentResources: [
                '{Workspace}'
              ]
              visualization: 'tiles'
              tileSettings: {
                titleContent: {
                  columnMatch: 'Severity'
                  formatter: 1
                }
                leftContent: {
                  columnMatch: 'count_'
                  formatter: 12
                  formatOptions: {
                    palette: 'auto'
                  }
                  numberFormat: {
                    unit: 17
                    options: {
                      maximumSignificantDigits: 3
                      maximumFractionDigits: 2
                    }
                  }
                }
                showBorder: true
              }
            }
            name: 'query - 2'
          }
          {
            type: 1
            content: {
              json: 'Enable collection of SysLog to your Log Analytics workspace with diagnostic settings on your AVS instance.'
            }
            name: 'text - 3'
          }
          {
            type: 3
            content: {
              version: 'KqlItem/1.0'
              query: 'AVSSyslog \r\n| where HostName in ({HostName})\r\n| where AppName in ({AppName})\r\n| where Severity in ({Severity}) or \'*\' in ({Severity})\r\n| project TimeGenerated, HostName, AppName, Facility, Severity, Message'
              size: 2
              timeContextFromParameter: 'TimeRange'
              queryType: 0
              resourceType: 'microsoft.operationalinsights/workspaces'
              crossComponentResources: [
                '{Workspace}'
              ]
              visualization: 'table'
              gridSettings: {
                formatters: [
                  {
                    columnMatch: 'Severity'
                    formatter: 18
                    formatOptions: {
                      thresholdsOptions: 'icons'
                      thresholdsGrid: [
                        {
                          operator: '=='
                          thresholdValue: 'debug'
                          representation: 'question'
                          text: '{0}{1}'
                        }
                        {
                          operator: '=='
                          thresholdValue: 'warn'
                          representation: '2'
                          text: '{0}{1}'
                        }
                        {
                          operator: '=='
                          thresholdValue: 'err'
                          representation: '3'
                          text: '{0}{1}'
                        }
                        {
                          operator: '=='
                          thresholdValue: 'notice'
                          representation: 'Normal'
                          text: '{0}{1}'
                        }
                        {
                          operator: '=='
                          thresholdValue: 'alert'
                          representation: 'Fired'
                          text: '{0}{1}'
                        }
                        {
                          operator: 'Default'
                          thresholdValue: null
                          representation: '1'
                          text: '{0}{1}'
                        }
                      ]
                    }
                  }
                  {
                    columnMatch: 'Message'
                    formatter: 7
                    formatOptions: {
                      linkTarget: 'CellDetails'
                      linkIsContextBlade: true
                    }
                  }
                ]
                filter: true
              }
            }
            name: 'query - 1'
          }
        ]
      }
      conditionalVisibility: {
        parameterName: 'Tab'
        comparison: 'isEqualTo'
        value: 'Operations'
      }
      name: 'group - SysLog'
    }
    {
      type: 12
      content: {
        version: 'NotebookGroup/1.0'
        groupType: 'editable'
        loadType: 'always'
        items: [
          {
            type: 3
            content: {
              version: 'KqlItem/1.0'
              query: 'where  type == "microsoft.avs/privateclouds"\r\n| where id in ({AVSInstance})\r\n| summarize count() by location'
              size: 3
              title: 'AVS Instance Locations'
              queryType: 1
              resourceType: 'microsoft.resourcegraph/resources'
              crossComponentResources: [
                '{Subscription}'
              ]
              visualization: 'map'
              mapSettings: {
                locInfo: 'AzureLoc'
                locInfoColumn: 'location'
                sizeSettings: 'count_'
                sizeAggregation: 'Sum'
                minSize: 20
                maxSize: 70
                labelSettings: 'location'
                legendMetric: 'count_'
                legendAggregation: 'Sum'
                itemColorSettings: {
                  nodeColorField: 'count_'
                  colorAggregation: 'Sum'
                  type: 'heatmap'
                  heatmapPalette: 'orangeBlue'
                }
              }
            }
            name: 'query - 0'
          }
        ]
      }
      conditionalVisibility: {
        parameterName: 'Tab'
        comparison: 'isEqualTo'
        value: 'Overview'
      }
      name: 'Group - Location'
    }
    {
      type: 12
      content: {
        version: 'NotebookGroup/1.0'
        groupType: 'editable'
        loadType: 'always'
        items: [
          {
            type: 1
            content: {
              json: '### Select a subscription to access quota information'
            }
            name: 'text - 3 - Copy'
          }
          {
            type: 9
            content: {
              version: 'KqlParameterItem/1.0'
              parameters: [
                {
                  id: '468a2975-ba5d-43e2-a55b-c3bd89257722'
                  version: 'KqlParameterItem/1.0'
                  name: 'Subscription'
                  type: 6
                  isRequired: true
                  isGlobal: true
                  typeSettings: {
                    additionalResourceOptions: [
                      'value::1'
                    ]
                    includeAll: true
                    showDefault: false
                  }
                  timeContext: {
                    durationMs: 86400000
                  }
                  value: 'value::1'
                }
              ]
              style: 'pills'
              queryType: 0
              resourceType: 'microsoft.operationalinsights/workspaces'
            }
            name: 'parameters - 0'
          }
          {
            type: 9
            content: {
              version: 'KqlParameterItem/1.0'
              parameters: [
                {
                  id: '1afa403e-9976-4ee8-8764-5348d1217903'
                  version: 'KqlParameterItem/1.0'
                  name: 'eastus'
                  type: 1
                  query: '{"version":"ARMEndpoint/1.0","data":null,"headers":[],"method":"POST","path":"/subscriptions/{Subscription:subscriptionid}/providers/Microsoft.AVS/locations/eastus/checkQuotaAvailability?api-version=2021-12-01","urlParams":[],"batchDisabled":false,"transformers":[{"type":"jsonpath","settings":{"tablePath":"","columns":[{"path":"$.hostsRemaining.he","columnid":"he","columnType":"long"}]}}]}'
                  isHiddenWhenLocked: true
                  timeContext: {
                    durationMs: 86400000
                  }
                  queryType: 12
                  value: null
                }
                {
                  id: 'f16d9346-a225-4205-93ce-3a21d223e579'
                  version: 'KqlParameterItem/1.0'
                  name: 'germanywestcentral'
                  type: 1
                  query: '{"version":"ARMEndpoint/1.0","data":null,"headers":[],"method":"POST","path":"/subscriptions/{Subscription:subscriptionid}/providers/Microsoft.AVS/locations/germanywestcentral/checkQuotaAvailability?api-version=2021-12-01","urlParams":[],"batchDisabled":false,"transformers":[{"type":"jsonpath","settings":{"tablePath":"","columns":[{"path":"$.hostsRemaining.he","columnid":"he","columnType":"long"}]}}]}'
                  isHiddenWhenLocked: true
                  timeContext: {
                    durationMs: 86400000
                  }
                  queryType: 12
                  value: null
                }
                {
                  id: 'ea8281bf-abfb-430b-ac91-e0cbabc74568'
                  version: 'KqlParameterItem/1.0'
                  name: 'northeurope'
                  type: 1
                  query: '{"version":"ARMEndpoint/1.0","data":null,"headers":[],"method":"POST","path":"/subscriptions/{Subscription:subscriptionid}/providers/Microsoft.AVS/locations/northeurope/checkQuotaAvailability?api-version=2021-12-01","urlParams":[],"batchDisabled":false,"transformers":[{"type":"jsonpath","settings":{"columns":[{"path":"$.hostsRemaining.he","columnid":"he","columnType":"long"}]}}]}'
                  isHiddenWhenLocked: true
                  timeContext: {
                    durationMs: 86400000
                  }
                  queryType: 12
                  value: null
                }
                {
                  id: 'f5fd95e4-fc19-48a1-9091-5968dfe54741'
                  version: 'KqlParameterItem/1.0'
                  name: 'brazilsouth'
                  type: 1
                  query: '{"version":"ARMEndpoint/1.0","data":null,"headers":[],"method":"POST","path":"/subscriptions/{Subscription:subscriptionid}/providers/Microsoft.AVS/locations/brazilsouth/checkQuotaAvailability?api-version=2021-12-01","urlParams":[],"batchDisabled":false,"transformers":[{"type":"jsonpath","settings":{"columns":[{"path":"$.hostsRemaining.he","columnid":"he","columnType":"long"}]}}]}'
                  isHiddenWhenLocked: true
                  timeContext: {
                    durationMs: 86400000
                  }
                  queryType: 12
                  value: null
                }
                {
                  id: '632a9f3f-d2ef-41b4-9cfa-b47ee8b4b505'
                  version: 'KqlParameterItem/1.0'
                  name: 'francecentral'
                  type: 1
                  query: '{"version":"ARMEndpoint/1.0","data":null,"headers":[],"method":"POST","path":"/subscriptions/{Subscription:subscriptionid}/providers/Microsoft.AVS/locations/francecentral/checkQuotaAvailability?api-version=2021-12-01","urlParams":[],"batchDisabled":false,"transformers":[{"type":"jsonpath","settings":{"columns":[{"path":"$.hostsRemaining.he","columnid":"he","columnType":"long"}]}}]}'
                  isHiddenWhenLocked: true
                  timeContext: {
                    durationMs: 86400000
                  }
                  queryType: 12
                  value: null
                }
                {
                  id: '59ccceb3-74da-4b17-8ad1-ad9befd8db21'
                  version: 'KqlParameterItem/1.0'
                  name: 'westcentralus'
                  type: 1
                  query: '{"version":"ARMEndpoint/1.0","data":null,"headers":[],"method":"POST","path":"/subscriptions/{Subscription:subscriptionid}/providers/Microsoft.AVS/locations/westcentralus/checkQuotaAvailability?api-version=2021-12-01","urlParams":[],"batchDisabled":false,"transformers":[{"type":"jsonpath","settings":{"columns":[{"path":"$.hostsRemaining.he","columnid":"he","columnType":"long"}]}}]}'
                  isHiddenWhenLocked: true
                  timeContext: {
                    durationMs: 86400000
                  }
                  queryType: 12
                  value: null
                }
                {
                  id: '3b0ec634-2f2c-49cb-8193-50b0d8ea4c3c'
                  version: 'KqlParameterItem/1.0'
                  name: 'northcentralus'
                  type: 1
                  query: '{"version":"ARMEndpoint/1.0","data":null,"headers":[],"method":"POST","path":"/subscriptions/{Subscription:subscriptionid}/providers/Microsoft.AVS/locations/northcentralus/checkQuotaAvailability?api-version=2021-12-01","urlParams":[],"batchDisabled":false,"transformers":[{"type":"jsonpath","settings":{"columns":[{"path":"$.hostsRemaining.he","columnid":"he","columnType":"long"}]}}]}'
                  isHiddenWhenLocked: true
                  timeContext: {
                    durationMs: 86400000
                  }
                  queryType: 12
                  value: null
                }
                {
                  id: 'ca440088-1260-4a72-9540-4bd7d9304718'
                  version: 'KqlParameterItem/1.0'
                  name: 'westus'
                  type: 1
                  query: '{"version":"ARMEndpoint/1.0","data":null,"headers":[],"method":"POST","path":"/subscriptions/{Subscription:subscriptionid}/providers/Microsoft.AVS/locations/westus/checkQuotaAvailability?api-version=2021-12-01","urlParams":[],"batchDisabled":false,"transformers":[{"type":"jsonpath","settings":{"columns":[{"path":"$.hostsRemaining.he","columnid":"he","columnType":"long"}]}}]}'
                  isHiddenWhenLocked: true
                  timeContext: {
                    durationMs: 86400000
                  }
                  queryType: 12
                  value: null
                }
                {
                  id: '93ad664b-8ae2-4c92-8a4b-094237d01df9'
                  version: 'KqlParameterItem/1.0'
                  name: 'westeurope'
                  type: 1
                  query: '{"version":"ARMEndpoint/1.0","data":null,"headers":[],"method":"POST","path":"/subscriptions/{Subscription:subscriptionid}/providers/Microsoft.AVS/locations/westeurope/checkQuotaAvailability?api-version=2021-12-01","urlParams":[],"batchDisabled":false,"transformers":[{"type":"jsonpath","settings":{"columns":[{"path":"$.hostsRemaining.he","columnid":"he","columnType":"long"}]}}]}'
                  isHiddenWhenLocked: true
                  timeContext: {
                    durationMs: 86400000
                  }
                  queryType: 12
                  value: null
                }
                {
                  id: '31673271-3f9e-4312-9077-64e38c40e95e'
                  version: 'KqlParameterItem/1.0'
                  name: 'australiaeast'
                  type: 1
                  query: '{"version":"ARMEndpoint/1.0","data":null,"headers":[],"method":"POST","path":"/subscriptions/{Subscription:subscriptionid}/providers/Microsoft.AVS/locations/australiaeast/checkQuotaAvailability?api-version=2021-12-01","urlParams":[],"batchDisabled":false,"transformers":[{"type":"jsonpath","settings":{"tablePath":"$.hostsRemaining.he","columns":[]}}]}'
                  isHiddenWhenLocked: true
                  timeContext: {
                    durationMs: 86400000
                  }
                  queryType: 12
                  value: null
                }
                {
                  id: 'f4760aef-ad3e-4b47-9e68-611242bfe019'
                  version: 'KqlParameterItem/1.0'
                  name: 'southcentralus'
                  type: 1
                  query: '{"version":"ARMEndpoint/1.0","data":null,"headers":[],"method":"POST","path":"/subscriptions/{Subscription:subscriptionid}/providers/Microsoft.AVS/locations/southcentralus/checkQuotaAvailability?api-version=2021-12-01","urlParams":[],"batchDisabled":false,"transformers":[{"type":"jsonpath","settings":{"columns":[{"path":"$.hostsRemaining.he","columnid":"he","columnType":"long"}]}}]}'
                  isHiddenWhenLocked: true
                  timeContext: {
                    durationMs: 86400000
                  }
                  queryType: 12
                  value: null
                }
                {
                  id: '8f661698-07c6-4e17-ac26-5b3bf0d6c0b9'
                  version: 'KqlParameterItem/1.0'
                  name: 'japaneast'
                  type: 1
                  query: '{"version":"ARMEndpoint/1.0","data":null,"headers":[],"method":"POST","path":"/subscriptions/{Subscription:subscriptionid}/providers/Microsoft.AVS/locations/japaneast/checkQuotaAvailability?api-version=2021-12-01","urlParams":[],"batchDisabled":false,"transformers":[{"type":"jsonpath","settings":{"tablePath":"","columns":[{"path":"$.hostsRemaining.he","columnid":"he","columnType":"long"}]}}]}'
                  isHiddenWhenLocked: true
                  timeContext: {
                    durationMs: 86400000
                  }
                  queryType: 12
                  value: null
                }
                {
                  id: '613f2d38-69c8-4cac-98fb-4601c2a084d0'
                  version: 'KqlParameterItem/1.0'
                  name: 'japanwest'
                  type: 1
                  query: '{"version":"ARMEndpoint/1.0","data":null,"headers":[],"method":"POST","path":"/subscriptions/{Subscription:subscriptionid}/providers/Microsoft.AVS/locations/japanwest/checkQuotaAvailability?api-version=2021-12-01","urlParams":[],"batchDisabled":false,"transformers":[{"type":"jsonpath","settings":{"columns":[{"path":"$.hostsRemaining.he","columnid":"he","columnType":"long"}]}}]}'
                  isHiddenWhenLocked: true
                  timeContext: {
                    durationMs: 86400000
                  }
                  queryType: 12
                  value: null
                }
                {
                  id: '4d91dcc2-cd6a-4b54-ac12-e55df518979b'
                  version: 'KqlParameterItem/1.0'
                  name: 'uksouth'
                  type: 1
                  query: '{"version":"ARMEndpoint/1.0","data":null,"headers":[],"method":"POST","path":"/subscriptions/{Subscription:subscriptionid}/providers/Microsoft.AVS/locations/uksouth/checkQuotaAvailability?api-version=2021-12-01","urlParams":[],"batchDisabled":false,"transformers":[{"type":"jsonpath","settings":{"columns":[{"path":"$.hostsRemaining.he","columnid":"he","columnType":"long"}]}}]}'
                  isHiddenWhenLocked: true
                  timeContext: {
                    durationMs: 86400000
                  }
                  queryType: 12
                  value: null
                }
                {
                  id: '1ccf2914-19a8-44c0-a59b-0912fe38294a'
                  version: 'KqlParameterItem/1.0'
                  name: 'canadacentral'
                  type: 1
                  query: '{"version":"ARMEndpoint/1.0","data":null,"headers":[],"method":"POST","path":"/subscriptions/{Subscription:subscriptionid}/providers/Microsoft.AVS/locations/canadacentral/checkQuotaAvailability?api-version=2021-12-01","urlParams":[],"batchDisabled":false,"transformers":[{"type":"jsonpath","settings":{"columns":[{"path":"$.hostsRemaining.he","columnid":"he","columnType":"long"}]}}]}'
                  isHiddenWhenLocked: true
                  timeContext: {
                    durationMs: 86400000
                  }
                  queryType: 12
                  value: null
                }
                {
                  id: '45318b9a-d335-4585-be14-6d1a7e28c525'
                  version: 'KqlParameterItem/1.0'
                  name: 'southeastasia'
                  type: 1
                  query: '{"version":"ARMEndpoint/1.0","data":null,"headers":[],"method":"POST","path":"/subscriptions/{Subscription:subscriptionid}/providers/Microsoft.AVS/locations/southeastasia/checkQuotaAvailability?api-version=2021-12-01","urlParams":[],"batchDisabled":false,"transformers":[{"type":"jsonpath","settings":{"columns":[{"path":"$.hostsRemaining.he","columnid":"he","columnType":"long"}]}}]}'
                  isHiddenWhenLocked: true
                  timeContext: {
                    durationMs: 86400000
                  }
                  queryType: 12
                  value: null
                }
                {
                  id: 'b115ff88-763a-4e60-ba5d-df9e2c98e8c3'
                  version: 'KqlParameterItem/1.0'
                  name: 'ukwest'
                  type: 1
                  query: '{"version":"ARMEndpoint/1.0","data":null,"headers":[],"method":"POST","path":"/subscriptions/{Subscription:subscriptionid}/providers/Microsoft.AVS/locations/ukwest/checkQuotaAvailability?api-version=2021-12-01","urlParams":[],"batchDisabled":false,"transformers":[{"type":"jsonpath","settings":{"columns":[{"path":"$.hostsRemaining.he","columnid":"he","columnType":"long"}]}}]}'
                  isHiddenWhenLocked: true
                  timeContext: {
                    durationMs: 86400000
                  }
                  queryType: 12
                  value: null
                }
                {
                  id: 'b6034f71-ded9-40ee-8b1c-eeb03a82bfe8'
                  version: 'KqlParameterItem/1.0'
                  name: 'eastus2'
                  type: 1
                  query: '{"version":"ARMEndpoint/1.0","data":null,"headers":[],"method":"POST","path":"/subscriptions/{Subscription:subscriptionid}/providers/Microsoft.AVS/locations/eastus2/checkQuotaAvailability?api-version=2021-12-01","urlParams":[],"batchDisabled":false,"transformers":[{"type":"jsonpath","settings":{"columns":[{"path":"$.hostsRemaining.he","columnid":"he","columnType":"long"}]}}]}'
                  isHiddenWhenLocked: true
                  timeContext: {
                    durationMs: 86400000
                  }
                  queryType: 12
                  value: null
                }
                {
                  id: '07ba4c6c-3eba-4d88-8158-fa18f45e73fc'
                  version: 'KqlParameterItem/1.0'
                  name: 'centralus'
                  type: 1
                  query: '{"version":"ARMEndpoint/1.0","data":null,"headers":[],"method":"POST","path":"/subscriptions/{Subscription:subscriptionid}/providers/Microsoft.AVS/locations/centralus/checkQuotaAvailability?api-version=2021-12-01","urlParams":[],"batchDisabled":false,"transformers":[{"type":"jsonpath","settings":{"columns":[{"path":"$.hostsRemaining.he","columnid":"he","columnType":"long"}]}}]}'
                  isHiddenWhenLocked: true
                  timeContext: {
                    durationMs: 86400000
                  }
                  queryType: 12
                  value: null
                }
                {
                  id: 'e102f6df-36a0-4bd2-9634-b8b5fdcd9a52'
                  version: 'KqlParameterItem/1.0'
                  name: 'australiasoutheast'
                  type: 1
                  query: '{"version":"ARMEndpoint/1.0","data":null,"headers":[],"method":"POST","path":"/subscriptions/{Subscription:subscriptionid}/providers/Microsoft.AVS/locations/australiasoutheast/checkQuotaAvailability?api-version=2021-12-01","urlParams":[],"batchDisabled":false,"transformers":[{"type":"jsonpath","settings":{"columns":[{"path":"$.hostsRemaining.he","columnid":"he","columnType":"long"}]}}]}'
                  isHiddenWhenLocked: true
                  timeContext: {
                    durationMs: 86400000
                  }
                  queryType: 12
                  value: null
                }
                {
                  id: 'a8098363-78a2-464f-8fc1-49e9d34afcdf'
                  version: 'KqlParameterItem/1.0'
                  name: 'canadaeast'
                  type: 1
                  query: '{"version":"ARMEndpoint/1.0","data":null,"headers":[],"method":"POST","path":"/subscriptions/{Subscription:subscriptionid}/providers/Microsoft.AVS/locations/canadaeast/checkQuotaAvailability?api-version=2021-12-01","urlParams":[],"batchDisabled":false,"transformers":[{"type":"jsonpath","settings":{"columns":[{"path":"$.hostsRemaining.he","columnid":"he","columnType":"long"}]}}]}'
                  isHiddenWhenLocked: true
                  timeContext: {
                    durationMs: 86400000
                  }
                  queryType: 12
                  value: null
                }
                {
                  id: 'b0bafe2e-6c7a-4e00-b2b9-44bdc2711489'
                  version: 'KqlParameterItem/1.0'
                  name: 'eastasia'
                  type: 1
                  query: '{"version":"ARMEndpoint/1.0","data":null,"headers":[],"method":"POST","path":"/subscriptions/{Subscription:subscriptionid}/providers/Microsoft.AVS/locations/eastasia/checkQuotaAvailability?api-version=2021-12-01","urlParams":[],"batchDisabled":false,"transformers":[{"type":"jsonpath","settings":{"columns":[{"path":"$.hostsRemaining.he","columnid":"he","columnType":"long"}]}}]}'
                  isHiddenWhenLocked: true
                  timeContext: {
                    durationMs: 86400000
                  }
                  queryType: 12
                  value: null
                }
                {
                  version: 'KqlParameterItem/1.0'
                  name: 'southafricanorth'
                  type: 1
                  query: '{"version":"ARMEndpoint/1.0","data":null,"headers":[],"method":"POST","path":"/subscriptions/{Subscription:subscriptionid}/providers/Microsoft.AVS/locations/southafricanorth/checkQuotaAvailability?api-version=2021-12-01","urlParams":[],"batchDisabled":false,"transformers":[{"type":"jsonpath","settings":{"columns":[{"path":"$.hostsRemaining.he","columnid":"he","columnType":"long"}]}}]}'
                  isHiddenWhenLocked: true
                  timeContext: {
                    durationMs: 86400000
                  }
                  queryType: 12
                  id: '4a6521de-68e7-4079-8e63-672737025eac'
                  value: null
                }
              ]
              style: 'pills'
              queryType: 12
            }
            name: 'AVS Available Quota map'
          }
          {
            type: 3
            content: {
              version: 'KqlItem/1.0'
              query: ''
              size: 2
              exportToExcelOptions: 'all'
              queryType: 2
              visualization: 'map'
              mapSettings: {
                locInfo: 'AzureLoc'
                locInfoColumn: 'Parameter name'
                sizeSettings: 'Value'
                sizeAggregation: 'Sum'
                minSize: 1
                minData: 0
                defaultSize: 0
                legendMetric: 'Value'
                legendAggregation: 'Average'
                itemColorSettings: {
                  nodeColorField: 'Value'
                  colorAggregation: 'Sum'
                  type: 'heatmap'
                  heatmapPalette: 'redGreen'
                }
                numberFormatSettings: {
                  unit: 17
                  options: {
                    style: 'decimal'
                    useGrouping: false
                  }
                }
              }
            }
            name: 'query - 1'
          }
          {
            type: 1
            content: {
              json: '# Legend\r\n- Red: No quota remaining\r\n- Yellow:  3 quota remaining\r\n- Green: > 3 quota remaining'
            }
            name: 'text - 3'
          }
        ]
      }
      conditionalVisibility: {
        parameterName: 'Tab'
        comparison: 'isEqualTo'
        value: 'Overview'
      }
      name: 'Group - Quota'
    }
    {
      type: 12
      content: {
        version: 'NotebookGroup/1.0'
        groupType: 'editable'
        items: [
          {
            type: 1
            content: {
              json: '## Networking Overview\r\nThis tab provides visibility into AVS networking components including ExpressRoute circuits, GlobalReach connections, and circuit authorizations.'
            }
            name: 'text - networking-header'
          }
          {
            type: 3
            content: {
              version: 'KqlItem/1.0'
              query: 'resources\r\n| where type == "microsoft.avs/privateclouds"\r\n| extend circuit = properties.circuit\r\n| extend expressRouteID = tostring(circuit.expressRouteID)\r\n| extend expressRoutePrivatePeeringID = tostring(circuit.expressRoutePrivatePeeringID)\r\n| extend primarySubnet = tostring(circuit.primarySubnet)\r\n| extend secondarySubnet = tostring(circuit.secondarySubnet)\r\n| project name, location, expressRouteID, expressRoutePrivatePeeringID, primarySubnet, secondarySubnet, subscriptionId'
              size: 0
              title: 'ExpressRoute Circuit Information'
              noDataMessage: 'No AVS Private Clouds found - ExpressRoute circuits will appear once AVS is deployed'
              showRefreshButton: true
              showExportToExcel: true
              queryType: 1
              resourceType: 'microsoft.resourcegraph/resources'
              crossComponentResources: [
                '{Subscription}'
              ]
              visualization: 'table'
              gridSettings: {
                formatters: [
                  {
                    columnMatch: 'expressRouteID'
                    formatter: 13
                    formatOptions: {
                      linkTarget: 'Resource'
                      showIcon: true
                    }
                  }
                ]
                filter: true
                labelSettings: [
                  {
                    columnId: 'name'
                    label: 'Private Cloud'
                  }
                  {
                    columnId: 'location'
                    label: 'Location'
                  }
                  {
                    columnId: 'expressRouteID'
                    label: 'ExpressRoute ID'
                  }
                  {
                    columnId: 'primarySubnet'
                    label: 'Primary Subnet'
                  }
                  {
                    columnId: 'secondarySubnet'
                    label: 'Secondary Subnet'
                  }
                ]
              }
            }
            name: 'query - expressroute'
          }
          {
            type: 3
            content: {
              version: 'KqlItem/1.0'
              query: 'resources\r\n| where type == "microsoft.avs/privateclouds/globalreachconnections"\r\n| extend pcName = tostring(split(id, "/")[8])\r\n| extend connectionStatus = tostring(properties.circuitConnectionStatus)\r\n| extend peerExpressRouteCircuit = tostring(properties.peerExpressRouteCircuit)\r\n| extend addressPrefix = tostring(properties.addressPrefix)\r\n| extend provisioningState = tostring(properties.provisioningState)\r\n| project name, pcName, connectionStatus, peerExpressRouteCircuit, addressPrefix, provisioningState, resourceGroup'
              size: 0
              title: 'GlobalReach Connections'
              noDataMessage: 'No GlobalReach connections configured - Use GlobalReach to connect AVS to on-premises ExpressRoute circuits'
              showRefreshButton: true
              showExportToExcel: true
              queryType: 1
              resourceType: 'microsoft.resourcegraph/resources'
              crossComponentResources: [
                '{Subscription}'
              ]
              visualization: 'table'
              gridSettings: {
                formatters: [
                  {
                    columnMatch: 'connectionStatus'
                    formatter: 18
                    formatOptions: {
                      thresholdsOptions: 'icons'
                      thresholdsGrid: [
                        {
                          operator: '=='
                          thresholdValue: 'Connected'
                          representation: 'success'
                          text: '{0}{1}'
                        }
                        {
                          operator: 'Default'
                          thresholdValue: null
                          representation: 'warning'
                          text: '{0}{1}'
                        }
                      ]
                    }
                  }
                  {
                    columnMatch: 'provisioningState'
                    formatter: 18
                    formatOptions: {
                      thresholdsOptions: 'icons'
                      thresholdsGrid: [
                        {
                          operator: '=='
                          thresholdValue: 'Succeeded'
                          representation: 'success'
                          text: '{0}{1}'
                        }
                        {
                          operator: 'Default'
                          thresholdValue: null
                          representation: 'warning'
                          text: '{0}{1}'
                        }
                      ]
                    }
                  }
                ]
                filter: true
                labelSettings: [
                  {
                    columnId: 'name'
                    label: 'Connection Name'
                  }
                  {
                    columnId: 'pcName'
                    label: 'Private Cloud'
                  }
                  {
                    columnId: 'connectionStatus'
                    label: 'Status'
                  }
                  {
                    columnId: 'peerExpressRouteCircuit'
                    label: 'Peer Circuit'
                  }
                  {
                    columnId: 'addressPrefix'
                    label: 'Address Prefix'
                  }
                  {
                    columnId: 'provisioningState'
                    label: 'Provisioning'
                  }
                ]
              }
            }
            name: 'query - globalreach'
          }
          {
            type: 3
            content: {
              version: 'KqlItem/1.0'
              query: 'resources\r\n| where type == "microsoft.avs/privateclouds/authorizations"\r\n| extend pcName = tostring(split(id, "/")[8])\r\n| extend expressRouteAuthorizationKey = tostring(properties.expressRouteAuthorizationKey)\r\n| extend expressRouteAuthorizationId = tostring(properties.expressRouteAuthorizationId)\r\n| extend provisioningState = tostring(properties.provisioningState)\r\n| project name, pcName, provisioningState, expressRouteAuthorizationId, resourceGroup'
              size: 0
              title: 'ExpressRoute Authorizations'
              noDataMessage: 'No ExpressRoute authorizations created - Authorizations are required for VNet gateway connections'
              showRefreshButton: true
              showExportToExcel: true
              queryType: 1
              resourceType: 'microsoft.resourcegraph/resources'
              crossComponentResources: [
                '{Subscription}'
              ]
              visualization: 'table'
              gridSettings: {
                formatters: [
                  {
                    columnMatch: 'provisioningState'
                    formatter: 18
                    formatOptions: {
                      thresholdsOptions: 'icons'
                      thresholdsGrid: [
                        {
                          operator: '=='
                          thresholdValue: 'Succeeded'
                          representation: 'success'
                          text: '{0}{1}'
                        }
                        {
                          operator: 'Default'
                          thresholdValue: null
                          representation: 'warning'
                          text: '{0}{1}'
                        }
                      ]
                    }
                  }
                ]
                filter: true
                labelSettings: [
                  {
                    columnId: 'name'
                    label: 'Authorization Name'
                  }
                  {
                    columnId: 'pcName'
                    label: 'Private Cloud'
                  }
                  {
                    columnId: 'provisioningState'
                    label: 'Status'
                  }
                  {
                    columnId: 'expressRouteAuthorizationId'
                    label: 'Authorization ID'
                  }
                ]
              }
            }
            name: 'query - authorizations'
          }
        ]
      }
      conditionalVisibility: {
        parameterName: 'Tab'
        comparison: 'isEqualTo'
        value: 'Networking'
      }
      name: 'Group - Networking'
    }
    {
      type: 12
      content: {
        version: 'NotebookGroup/1.0'
        groupType: 'editable'
        items: [
          {
            type: 1
            content: {
              json: '## Security & Compliance\r\nNSX-T Distributed Firewall activity, rule change audit trail, and security events from AVS SysLog data.\r\n\r\n> **Prerequisites:** Enable `allLogs` diagnostic category on your AVS Private Cloud. For DFW packet logs, also enable the **Logging** toggle on each firewall rule in NSX-T Manager → Security → Distributed Firewall.'
            }
            name: 'text - security-header'
          }
          {
            type: 3
            content: {
              version: 'KqlItem/1.0'
              query: 'AVSSyslog\r\n| where AppName == "NSX"\r\n| where Message has_any ("DFW", "Firewall", "SecurityPolicy", "SecurityRule", "DfwSecurityPolicy", "INET match", "INET6 match", "dfwpktlogs", "FIREWALL_PKTLOG") or Message matches regex @"\\d+ (?:PASS|DROP|REJECT|ALLOW)"\r\n| summarize EventCount = count() by bin(TimeGenerated, 1h)\r\n| order by TimeGenerated desc'
              size: 0
              title: 'NSX DFW Activity Over Time'
              noDataMessage: 'No DFW events found - Enable allLogs diagnostic category on your AVS Private Cloud'
              timeContextFromParameter: 'TimeRange'
              queryType: 0
              resourceType: 'microsoft.operationalinsights/workspaces'
              crossComponentResources: [
                '{Workspace}'
              ]
              visualization: 'areachart'
              chartSettings: {
                showDataPoints: true
                xAxis: 'TimeGenerated'
                yAxis: [
                  'EventCount'
                ]
                seriesLabelSettings: [
                  {
                    seriesName: 'EventCount'
                    label: 'Firewall Events'
                    color: 'blue'
                  }
                ]
              }
            }
            customWidth: '50'
            name: 'query - dfw-timeline'
          }
          {
            type: 3
            content: {
              version: 'KqlItem/1.0'
              query: 'AVSSyslog\r\n| where AppName == "NSX"\r\n| where Message has_any ("DfwSecurityPolicy", "SecurityRule", "SecurityPolicy", "FirewallFilter", "DFW", "Firewall")\r\n| extend Operation = case(\r\n    Message has "PatchSecurityRule" or Message has "UpdateSecurityRule", "Rule Update",\r\n    Message has "PatchSecurityPolicyForDomain", "Policy Update",\r\n    Message has "Disabled Rule", "Rule Disabled",\r\n    Message has "FirewallSectionSummary", "Status Check",\r\n    Message has "DFW_TIMER", "Timer",\r\n    Message has "GetRulesByFilter" or Message has "GetSectionsByFilter", "Rule Query",\r\n    "Other")\r\n| summarize Count = count() by Operation'
              size: 0
              title: 'DFW Operations Breakdown'
              noDataMessage: 'No DFW operations recorded - Enable allLogs diagnostic category'
              timeContextFromParameter: 'TimeRange'
              queryType: 0
              resourceType: 'microsoft.operationalinsights/workspaces'
              crossComponentResources: [
                '{Workspace}'
              ]
              visualization: 'piechart'
              chartSettings: {
                seriesLabelSettings: [
                  {
                    seriesName: 'Rule Update'
                    color: 'blue'
                  }
                  {
                    seriesName: 'Policy Update'
                    color: 'purple'
                  }
                  {
                    seriesName: 'Rule Disabled'
                    color: 'orange'
                  }
                  {
                    seriesName: 'Status Check'
                    color: 'green'
                  }
                  {
                    seriesName: 'Timer'
                    color: 'gray'
                  }
                  {
                    seriesName: 'Rule Query'
                    color: 'turquoise'
                  }
                ]
              }
            }
            customWidth: '50'
            name: 'query - dfw-actions'
          }
          {
            type: 3
            content: {
              version: 'KqlItem/1.0'
              query: 'let failed_ssh = AVSSyslog\r\n| where AppName == "sshd"\r\n| where Message has_any ("Failed", "Invalid user", "authentication failure")\r\n| summarize Count=count();\r\nlet nsx_errors = AVSSyslog\r\n| where AppName == "NSX" and Severity in ("err","error")\r\n| summarize Count=count();\r\nlet hcx_errors = AVSSyslog\r\n| where AppName == "hcx-app" and Severity in ("err","error")\r\n| summarize Count=count();\r\nlet log_errors = AVSSyslog\r\n| where AppName == "rsyslogd" and Severity in ("err","error")\r\n| summarize Count=count();\r\nlet ssh_val = toscalar(failed_ssh);\r\nlet nsx_val = toscalar(nsx_errors);\r\nlet hcx_val = toscalar(hcx_errors);\r\nlet log_val = toscalar(log_errors);\r\ndatatable(Category:string, Count:long, Icon:string) [\r\n  "Failed SSH Logins", ssh_val, case(ssh_val > 100, "3", ssh_val > 0, "2", "1"),\r\n  "NSX Errors", nsx_val, case(nsx_val > 50, "3", nsx_val > 0, "2", "1"),\r\n  "HCX Errors", hcx_val, case(hcx_val > 50, "3", hcx_val > 0, "2", "1"),\r\n  "Log Pipeline Issues", log_val, case(log_val > 100, "3", log_val > 0, "2", "1")\r\n]'
              size: 4
              title: 'Security Insights'
              noDataMessage: 'No security data available'
              timeContextFromParameter: 'TimeRange'
              queryType: 0
              resourceType: 'microsoft.operationalinsights/workspaces'
              crossComponentResources: [
                '{Workspace}'
              ]
              visualization: 'tiles'
              tileSettings: {
                titleContent: {
                  columnMatch: 'Category'
                  formatter: 1
                }
                leftContent: {
                  columnMatch: 'Count'
                  formatter: 12
                  formatOptions: {
                    palette: 'none'
                  }
                  numberFormat: {
                    unit: 17
                    options: {
                      style: 'decimal'
                      maximumFractionDigits: 0
                    }
                  }
                }
                showBorder: true
                sortCriteriaField: 'Count'
                sortOrderField: 2
              }
            }
            name: 'query - security-kpis'
          }
          {
            type: 3
            content: {
              version: 'KqlItem/1.0'
              query: 'AVSSyslog\r\n| where Severity in ("err", "error", "crit", "critical", "alert", "emerg", "emergency")\r\n| extend ErrorSummary = case(\r\n    AppName == "sshd" and Message has "Failed password", "SSH: Failed password attempt",\r\n    AppName == "sshd" and Message has "authentication failure", "SSH: Authentication failure",\r\n    AppName == "sshd" and Message has "kex_exchange_identification", "SSH: Key exchange failed (connection reset)",\r\n    AppName == "sshd" and Message has "Invalid user", "SSH: Invalid user attempt",\r\n    AppName == "NSX" and Message has "Error in rest call", strcat("NSX API: ", extract(@"error_message\\s*:\\s*([^}]+)", 1, Message)),\r\n    AppName == "NSX", strcat("NSX: ", substring(Message, 0, 80)),\r\n    AppName == "hcx-app", strcat("HCX: ", substring(Message, 0, 80)),\r\n    AppName == "rsyslogd" and Message has "larger than max msg size", "Rsyslog: Message too large (truncated)",\r\n    AppName == "rsyslogd", strcat("Rsyslog: ", substring(Message, 0, 80)),\r\n    strcat(AppName, ": ", substring(Message, 0, 80))\r\n)\r\n| summarize Count=count(), FirstSeen=min(TimeGenerated), LastSeen=max(TimeGenerated), Hosts=dcount(HostName) by ErrorSummary, AppName, Severity\r\n| extend Duration = iff(FirstSeen == LastSeen, "Single event", strcat(format_timespan(LastSeen - FirstSeen, "d") , "d ", format_timespan(LastSeen - FirstSeen, "h"), "h"))\r\n| extend Active = iff(LastSeen > ago(1h), true, false)\r\n| project ErrorSummary, AppName, Severity, Count, Hosts, FirstSeen, LastSeen, Active\r\n| order by Count desc\r\n| take 20'
              size: 0
              title: 'Top Security Events (Error & Above)'
              noDataMessage: 'No error-level events - Environment is healthy'
              timeContextFromParameter: 'TimeRange'
              showExportToExcel: true
              queryType: 0
              resourceType: 'microsoft.operationalinsights/workspaces'
              crossComponentResources: [
                '{Workspace}'
              ]
              visualization: 'table'
              gridSettings: {
                formatters: [
                  {
                    columnMatch: 'Severity'
                    formatter: 18
                    formatOptions: {
                      thresholdsOptions: 'colors'
                      thresholdsGrid: [
                        {
                          operator: 'regex'
                          thresholdValue: 'crit|critical'
                          representation: 'redBright'
                          text: '{0}{1}'
                        }
                        {
                          operator: 'regex'
                          thresholdValue: 'err|error'
                          representation: 'orange'
                          text: '{0}{1}'
                        }
                        {
                          operator: 'regex'
                          thresholdValue: 'emerg|emergency|alert'
                          representation: 'redDark'
                          text: '{0}{1}'
                        }
                        {
                          operator: 'Default'
                          thresholdValue: null
                          representation: 'yellow'
                          text: '{0}{1}'
                        }
                      ]
                    }
                  }
                  {
                    columnMatch: 'Count'
                    formatter: 8
                    formatOptions: {
                      palette: 'yellowOrangeRed'
                      aggregation: 'Sum'
                    }
                  }
                  {
                    columnMatch: 'Active'
                    formatter: 18
                    formatOptions: {
                      thresholdsOptions: 'icons'
                      thresholdsGrid: [
                        {
                          operator: '=='
                          thresholdValue: 'true'
                          representation: 'warning'
                          text: 'Active'
                        }
                        {
                          operator: '=='
                          thresholdValue: 'false'
                          representation: 'success'
                          text: 'Resolved'
                        }
                        {
                          operator: 'Default'
                          thresholdValue: null
                          representation: 'unknown'
                          text: '{0}{1}'
                        }
                      ]
                    }
                  }
                  {
                    columnMatch: 'Hosts'
                    formatter: 4
                    formatOptions: {
                      palette: 'blue'
                    }
                  }
                ]
                filter: true
                labelSettings: [
                  {
                    columnId: 'ErrorSummary'
                    label: 'Event'
                  }
                  {
                    columnId: 'AppName'
                    label: 'Source'
                  }
                  {
                    columnId: 'Count'
                    label: 'Occurrences'
                  }
                  {
                    columnId: 'Hosts'
                    label: 'Affected Hosts'
                  }
                  {
                    columnId: 'FirstSeen'
                    label: 'First Seen'
                  }
                  {
                    columnId: 'LastSeen'
                    label: 'Last Seen'
                  }
                  {
                    columnId: 'Active'
                    label: 'Status'
                  }
                ]
              }
            }
            name: 'query - top-security-events'
          }
          {
            type: 3
            content: {
              version: 'KqlItem/1.0'
              query: 'AVSSyslog\r\n| where AppName == "sshd"\r\n| where Message has_any ("Failed password", "Invalid user", "authentication failure")\r\n| parse Message with * "from " SourceIP " port" *\r\n| parse Message with * "rhost=" SourceIP2 " " *\r\n| extend IP = coalesce(SourceIP, SourceIP2)\r\n| parse Message with * "for " Username " from" *\r\n| parse Message with * "user=" Username2\r\n| extend User = coalesce(Username, Username2)\r\n| where isnotempty(IP)\r\n| summarize Attempts=count(), DistinctUsers=dcount(User), FirstSeen=min(TimeGenerated), LastSeen=max(TimeGenerated), Users=make_set(User, 5) by IP, HostName\r\n| extend UsersStr = strcat_array(Users, ", ")\r\n| project IP, HostName, Attempts, DistinctUsers, UsersStr, FirstSeen, LastSeen\r\n| order by Attempts desc\r\n| take 20'
              size: 0
              title: 'Failed SSH Login Attempts by Source'
              noDataMessage: 'No failed SSH login attempts detected'
              timeContextFromParameter: 'TimeRange'
              showExportToExcel: true
              queryType: 0
              resourceType: 'microsoft.operationalinsights/workspaces'
              crossComponentResources: [
                '{Workspace}'
              ]
              visualization: 'table'
              gridSettings: {
                formatters: [
                  {
                    columnMatch: 'Attempts'
                    formatter: 8
                    formatOptions: {
                      palette: 'yellowOrangeRed'
                      aggregation: 'Sum'
                    }
                  }
                  {
                    columnMatch: 'DistinctUsers'
                    formatter: 4
                    formatOptions: {
                      palette: 'blue'
                    }
                  }
                ]
                filter: true
                labelSettings: [
                  {
                    columnId: 'IP'
                    label: 'Source IP'
                  }
                  {
                    columnId: 'HostName'
                    label: 'Target Host'
                  }
                  {
                    columnId: 'Attempts'
                    label: 'Attempts'
                  }
                  {
                    columnId: 'DistinctUsers'
                    label: 'Unique Users'
                  }
                  {
                    columnId: 'UsersStr'
                    label: 'Usernames Tried'
                  }
                  {
                    columnId: 'FirstSeen'
                    label: 'First Seen'
                  }
                  {
                    columnId: 'LastSeen'
                    label: 'Last Seen'
                  }
                ]
              }
            }
            name: 'query - failed-ssh'
          }
          {
            type: 3
            content: {
              version: 'KqlItem/1.0'
              query: 'AVSSyslog\r\n| where AppName == "NSX"\r\n| where Message has_any ("DfwSecurityPolicy", "SecurityRule", "SecurityPolicy", "FirewallFilter")\r\n| where Message has "Operation="\r\n| parse Message with * \'UserName="\' User \'"\' *\r\n| parse Message with * \'ModuleName="\' Module \'"\' *\r\n| parse Message with * \'Operation="\' Operation \'",\' *\r\n| parse Message with * \'Operation status="\' Status \'"\' *\r\n| parse Message with * \'"display_name":"\' RuleName \'"\' *\r\n| parse Message with * \'"action":"\' RuleAction \'"\' *\r\n| parse Message with * \'"logged":\' LogEnabled \',\' *\r\n| project TimeGenerated, User, Module, Operation, Status, RuleName, RuleAction, LogEnabled, HostName\r\n| order by TimeGenerated desc\r\n| take 50'
              size: 0
              title: 'DFW Rule Change Audit Trail'
              noDataMessage: 'No DFW audit events - Enable allLogs diagnostic category on your AVS Private Cloud'
              timeContextFromParameter: 'TimeRange'
              showExportToExcel: true
              queryType: 0
              resourceType: 'microsoft.operationalinsights/workspaces'
              crossComponentResources: [
                '{Workspace}'
              ]
              visualization: 'table'
              gridSettings: {
                formatters: [
                  {
                    columnMatch: 'Status'
                    formatter: 18
                    formatOptions: {
                      thresholdsOptions: 'icons'
                      thresholdsGrid: [
                        {
                          operator: '=='
                          thresholdValue: 'success'
                          representation: 'success'
                          text: '{0}{1}'
                        }
                        {
                          operator: 'Default'
                          thresholdValue: null
                          representation: 'warning'
                          text: '{0}{1}'
                        }
                      ]
                    }
                  }
                  {
                    columnMatch: 'RuleAction'
                    formatter: 18
                    formatOptions: {
                      thresholdsOptions: 'colors'
                      thresholdsGrid: [
                        {
                          operator: '=='
                          thresholdValue: 'ALLOW'
                          representation: 'green'
                          text: '{0}{1}'
                        }
                        {
                          operator: '=='
                          thresholdValue: 'DROP'
                          representation: 'red'
                          text: '{0}{1}'
                        }
                        {
                          operator: '=='
                          thresholdValue: 'REJECT'
                          representation: 'orange'
                          text: '{0}{1}'
                        }
                        {
                          operator: 'Default'
                          thresholdValue: null
                          representation: 'blue'
                          text: '{0}{1}'
                        }
                      ]
                    }
                  }
                  {
                    columnMatch: 'LogEnabled'
                    formatter: 18
                    formatOptions: {
                      thresholdsOptions: 'icons'
                      thresholdsGrid: [
                        {
                          operator: '=='
                          thresholdValue: 'true'
                          representation: 'success'
                          text: 'Yes'
                        }
                        {
                          operator: '=='
                          thresholdValue: 'false'
                          representation: 'disabled'
                          text: 'No'
                        }
                        {
                          operator: 'Default'
                          thresholdValue: null
                          representation: 'unknown'
                          text: '{0}{1}'
                        }
                      ]
                    }
                  }
                ]
                filter: true
                labelSettings: [
                  {
                    columnId: 'User'
                    label: 'User'
                  }
                  {
                    columnId: 'Module'
                    label: 'Module'
                  }
                  {
                    columnId: 'Operation'
                    label: 'Operation'
                  }
                  {
                    columnId: 'Status'
                    label: 'Status'
                  }
                  {
                    columnId: 'RuleName'
                    label: 'Rule Name'
                  }
                  {
                    columnId: 'RuleAction'
                    label: 'Rule Action'
                  }
                  {
                    columnId: 'LogEnabled'
                    label: 'Logging'
                  }
                ]
              }
            }
            name: 'query - dfw-audit'
          }
          {
            type: 3
            content: {
              version: 'KqlItem/1.0'
              query: 'AVSSyslog\r\n| where AppName == "NSX"\r\n| where Message has_any ("INET match", "INET6 match", "dfwpktlogs", "FIREWALL_PKTLOG") or Message matches regex @"\\d+ (?:PASS|DROP|REJECT|ALLOW)"\r\n| extend Action = case(\r\n    Message has "PASS" or Message has "ALLOW", "Allow",\r\n    Message has "DROP", "Drop",\r\n    Message has "REJECT", "Reject",\r\n    "Other")\r\n| extend Protocol = extract(@"(TCP|UDP|ICMP|ICMPv6)", 1, Message)\r\n| extend SrcIP = extract(@"(\\d+\\.\\d+\\.\\d+\\.\\d+)", 1, Message)\r\n| project TimeGenerated, HostName, Action, Protocol, SrcIP, Severity, Message\r\n| order by TimeGenerated desc\r\n| take 100'
              size: 0
              title: 'DFW Packet Logs (Traffic Hits)'
              noDataMessage: 'No DFW packet logs yet - Packet logs appear when traffic hits rules with logging enabled'
              timeContextFromParameter: 'TimeRange'
              showExportToExcel: true
              queryType: 0
              resourceType: 'microsoft.operationalinsights/workspaces'
              crossComponentResources: [
                '{Workspace}'
              ]
              visualization: 'table'
              gridSettings: {
                formatters: [
                  {
                    columnMatch: 'Action'
                    formatter: 18
                    formatOptions: {
                      thresholdsOptions: 'colors'
                      thresholdsGrid: [
                        {
                          operator: '=='
                          thresholdValue: 'Allow'
                          representation: 'green'
                          text: '{0}{1}'
                        }
                        {
                          operator: '=='
                          thresholdValue: 'Drop'
                          representation: 'red'
                          text: '{0}{1}'
                        }
                        {
                          operator: '=='
                          thresholdValue: 'Reject'
                          representation: 'orange'
                          text: '{0}{1}'
                        }
                        {
                          operator: 'Default'
                          thresholdValue: null
                          representation: 'blue'
                          text: '{0}{1}'
                        }
                      ]
                    }
                  }
                  {
                    columnMatch: 'Severity'
                    formatter: 18
                    formatOptions: {
                      thresholdsOptions: 'icons'
                      thresholdsGrid: [
                        {
                          operator: '=='
                          thresholdValue: 'err'
                          representation: '3'
                          text: '{0}{1}'
                        }
                        {
                          operator: '=='
                          thresholdValue: 'warn'
                          representation: '2'
                          text: '{0}{1}'
                        }
                        {
                          operator: 'Default'
                          thresholdValue: null
                          representation: '1'
                          text: '{0}{1}'
                        }
                      ]
                    }
                  }
                  {
                    columnMatch: 'Message'
                    formatter: 7
                    formatOptions: {
                      linkTarget: 'CellDetails'
                      linkIsContextBlade: true
                    }
                  }
                ]
                filter: true
              }
            }
            name: 'query - dfw-packet-logs'
          }
        ]
      }
      conditionalVisibility: {
        parameterName: 'Tab'
        comparison: 'isEqualTo'
        value: 'Networking'
      }
      name: 'Group - Security'
    }
    {
      type: 12
      content: {
        version: 'NotebookGroup/1.0'
        groupType: 'editable'
        items: [
          {
            type: 1
            content: {
              json: '## Storage Overview\r\nThis tab provides visibility into vSAN storage, external datastores (ANF, Elastic SAN, Pure Cloud Block Store), and storage capacity.'
            }
            name: 'text - storage-header'
          }
          {
            type: 3
            content: {
              version: 'KqlItem/1.0'
              query: 'resources\r\n| where type == "microsoft.avs/privateclouds"\r\n| extend skuName = tostring(sku.name)\r\n| extend hostCount = toint(properties.managementCluster.clusterSize)\r\n| extend vsanCapacityTB = case(\r\n    skuName startswith "AV36P", hostCount * 19.2,\r\n    skuName startswith "AV36", hostCount * 15.4,\r\n    skuName startswith "AV52", hostCount * 38.4,\r\n    skuName startswith "AV64", hostCount * 30.7,\r\n    hostCount * 15.4)\r\n| project name, vsanCapacityTB'
              size: 3
              title: 'Storage Capacity Distribution by Private Cloud'
              noDataMessage: 'No AVS Private Clouds found'
              queryType: 1
              resourceType: 'microsoft.resourcegraph/resources'
              crossComponentResources: [
                '{Subscription}'
              ]
              visualization: 'piechart'
              chartSettings: {
                seriesLabelSettings: [
                  {
                    seriesName: 'vsanCapacityTB'
                    label: 'vSAN Capacity (TB)'
                  }
                ]
              }
            }
            customWidth: '50'
            name: 'query - storage-distribution'
          }
          {
            type: 3
            content: {
              version: 'KqlItem/1.0'
              query: 'AzureMetrics\r\n| where ResourceProvider == "MICROSOFT.AVS"\r\n| where MetricName in ("DiskUsedLatest", "DiskCapacityLatest")\r\n| where TimeGenerated {TimeRange}\r\n| summarize Value = max(Maximum) by MetricName\r\n| extend UsedGB = iif(MetricName == "DiskUsedLatest", Value, 0.0)\r\n| extend CapacityGB = iif(MetricName == "DiskCapacityLatest", Value, 0.0)\r\n| summarize UsedGB = sum(UsedGB), CapacityGB = sum(CapacityGB)\r\n| extend FreeGB = round(CapacityGB - UsedGB, 1)\r\n| extend UsedGB = round(UsedGB, 1)\r\n| project-away CapacityGB\r\n| evaluate narrow()\r\n| extend Category = case(Column == "UsedGB", "Used (GB)", Column == "FreeGB", "Free (GB)", Column)\r\n| project Category, Value = todecimal(Value)'
              size: 3
              title: 'vSAN Disk Used vs Free (GB)'
              noDataMessage: 'No disk usage data found. Ensure AVS diagnostics are configured to send metrics to the Log Analytics workspace.'
              timeContextFromParameter: 'TimeRange'
              queryType: 0
              resourceType: 'microsoft.operationalinsights/workspaces'
              crossComponentResources: [
                '{Workspace}'
              ]
              visualization: 'piechart'
              chartSettings: {
                seriesLabelSettings: [
                  {
                    seriesName: 'Used (GB)'
                    color: 'redBright'
                  }
                  {
                    seriesName: 'Free (GB)'
                    color: 'green'
                  }
                ]
              }
            }
            customWidth: '50'
            conditionalVisibility: {
              parameterName: 'Workspace'
              comparison: 'isNotEqualTo'
              value: ''
            }
            name: 'query - disk-used-pie'
          }
          {
            type: 3
            content: {
              version: 'KqlItem/1.0'
              query: 'resources\r\n| where type == "microsoft.avs/privateclouds"\r\n| where id in ({AVSInstance})\r\n| extend sku = tostring(sku.name)\r\n| extend hostCount = toint(properties.managementCluster.clusterSize)\r\n| extend vsanDatastoreCapacityTB = case(\r\n    sku startswith "AV36", hostCount * 15.4,\r\n    sku startswith "AV52", hostCount * 15.4,\r\n    sku startswith "AV64", hostCount * 15.4,\r\n    hostCount * 15.4)\r\n| extend vsanUsableCapacityTB = round(vsanDatastoreCapacityTB * 0.7, 1)\r\n| extend vcenterFqdn = tostring(properties.endpoints.vcsa)\r\n| extend nsxtFqdn = tostring(properties.endpoints.nsxtManager)\r\n| extend provisioningState = tostring(properties.provisioningState)\r\n| project name, sku, hostCount, vsanDatastoreCapacityTB, vsanUsableCapacityTB, vcenterFqdn, provisioningState'
              size: 0
              title: 'vSAN Storage Capacity'
              noDataMessage: 'Select an AVS Private Cloud to view storage capacity'
              showRefreshButton: true
              queryType: 1
              resourceType: 'microsoft.resourcegraph/resources'
              crossComponentResources: [
                '{Subscription}'
              ]
              visualization: 'table'
              gridSettings: {
                formatters: [
                  {
                    columnMatch: 'vsanDatastoreCapacityTB'
                    formatter: 4
                    formatOptions: {
                      palette: 'blue'
                    }
                    numberFormat: {
                      unit: 0
                      options: {
                        style: 'decimal'
                        maximumFractionDigits: 1
                      }
                    }
                  }
                  {
                    columnMatch: 'vsanUsableCapacityTB'
                    formatter: 4
                    formatOptions: {
                      palette: 'green'
                    }
                    numberFormat: {
                      unit: 0
                      options: {
                        style: 'decimal'
                        maximumFractionDigits: 1
                      }
                    }
                  }
                  {
                    columnMatch: 'provisioningState'
                    formatter: 18
                    formatOptions: {
                      thresholdsOptions: 'icons'
                      thresholdsGrid: [
                        {
                          operator: '=='
                          thresholdValue: 'Succeeded'
                          representation: 'success'
                          text: '{0}{1}'
                        }
                        {
                          operator: 'Default'
                          thresholdValue: null
                          representation: 'warning'
                          text: '{0}{1}'
                        }
                      ]
                    }
                  }
                ]
                filter: true
                labelSettings: [
                  {
                    columnId: 'name'
                    label: 'Private Cloud'
                  }
                  {
                    columnId: 'sku'
                    label: 'SKU'
                  }
                  {
                    columnId: 'hostCount'
                    label: 'Hosts'
                  }
                  {
                    columnId: 'vsanDatastoreCapacityTB'
                    label: 'vSAN Raw (TB)'
                  }
                  {
                    columnId: 'vsanUsableCapacityTB'
                    label: 'vSAN Usable (TB)'
                  }
                  {
                    columnId: 'vcenterFqdn'
                    label: 'vCenter'
                  }
                ]
              }
            }
            name: 'query - storage-capacity'
          }
          {
            type: 10
            content: {
              chartId: 'storage-vsan-capacity'
              version: 'MetricsItem/2.0'
              size: 0
              chartType: 2
              resourceType: 'Microsoft.AVS/privateClouds'
              metricScope: 0
              resourceParameter: 'AVSInstance'
              resourceIds: [
                '{AVSInstance}'
              ]
              timeContextFromParameter: 'TimeRange'
              timeContext: {
                durationMs: 172800000
              }
              metrics: [
                {
                  namespace: 'microsoft.avs/privateclouds'
                  metric: 'microsoft.avs/privateclouds--DiskUsedPercentage'
                  aggregation: 4
                  splitBy: 'dsname'
                }
              ]
              title: 'vSAN Disk Usage by Datastore (%)'
              showRefreshButton: true
              gridFormatType: 1
              gridSettings: {
                rowLimit: 10000
              }
              showOpenInMe: true
              fallbackResourceIds: []
            }
            customWidth: '50'
            conditionalVisibility: {
              parameterName: 'AVSInstance'
              comparison: 'isNotEqualTo'
              value: ''
            }
            name: 'metric - vsan-usage'
          }
          {
            type: 10
            content: {
              chartId: 'storage-effective-capacity'
              version: 'MetricsItem/2.0'
              size: 0
              chartType: 2
              resourceType: 'Microsoft.AVS/privateClouds'
              metricScope: 0
              resourceParameter: 'AVSInstance'
              resourceIds: [
                '{AVSInstance}'
              ]
              timeContextFromParameter: 'TimeRange'
              timeContext: {
                durationMs: 172800000
              }
              metrics: [
                {
                  namespace: 'microsoft.avs/privateclouds'
                  metric: 'microsoft.avs/privateclouds--DiskUsedLatest'
                  aggregation: 4
                  splitBy: 'dsname'
                }
              ]
              title: 'Datastore Disk Used (GB)'
              showRefreshButton: true
              gridFormatType: 1
              gridSettings: {
                rowLimit: 10000
              }
              showOpenInMe: true
              fallbackResourceIds: []
            }
            customWidth: '50'
            conditionalVisibility: {
              parameterName: 'AVSInstance'
              comparison: 'isNotEqualTo'
              value: ''
            }
            name: 'metric - datastore-disk-used'
          }
          {
            type: 3
            content: {
              version: 'KqlItem/1.0'
              query: 'resources\r\n| where type == "microsoft.avs/privateclouds/clusters/datastores"\r\n| extend pcName = tostring(split(id, "/")[8])\r\n| extend clusterName = tostring(split(id, "/")[10])\r\n| extend datastoreName = name\r\n| extend netAppVolume = tostring(properties.netAppVolume.id)\r\n| extend elasticSanVolume = tostring(properties.elasticSanVolume.targetIqn)\r\n| extend provisioningState = tostring(properties.provisioningState)\r\n| extend status = tostring(properties.status)\r\n| extend datastoreType = case(\r\n    isnotempty(netAppVolume), "ANF",\r\n    isnotempty(elasticSanVolume), "Elastic SAN",\r\n    "Pure Storage")\r\n| project datastoreName, pcName, clusterName, datastoreType, status, provisioningState, resourceGroup, subscriptionId'
              size: 0
              title: 'External Datastores'
              noDataMessage: 'No external datastores attached. AVS supports ANF, Elastic SAN, and Pure Cloud Block Store as external datastores.'
              showRefreshButton: true
              showExportToExcel: true
              queryType: 1
              resourceType: 'microsoft.resourcegraph/resources'
              crossComponentResources: [
                '{Subscription}'
              ]
              visualization: 'table'
              gridSettings: {
                formatters: [
                  {
                    columnMatch: 'datastoreType'
                    formatter: 18
                    formatOptions: {
                      thresholdsOptions: 'colors'
                      thresholdsGrid: [
                        {
                          operator: '=='
                          thresholdValue: 'ANF'
                          representation: 'blue'
                          text: '{0}{1}'
                        }
                        {
                          operator: '=='
                          thresholdValue: 'Elastic SAN'
                          representation: 'purple'
                          text: '{0}{1}'
                        }
                        {
                          operator: '=='
                          thresholdValue: 'Pure Storage'
                          representation: 'orange'
                          text: '{0}{1}'
                        }
                        {
                          operator: 'Default'
                          thresholdValue: null
                          representation: 'gray'
                          text: '{0}{1}'
                        }
                      ]
                    }
                  }
                  {
                    columnMatch: 'status'
                    formatter: 18
                    formatOptions: {
                      thresholdsOptions: 'icons'
                      thresholdsGrid: [
                        {
                          operator: '=='
                          thresholdValue: 'Accessible'
                          representation: 'success'
                          text: '{0}{1}'
                        }
                        {
                          operator: '=='
                          thresholdValue: 'Attached'
                          representation: 'success'
                          text: '{0}{1}'
                        }
                        {
                          operator: 'Default'
                          thresholdValue: null
                          representation: 'warning'
                          text: '{0}{1}'
                        }
                      ]
                    }
                  }
                  {
                    columnMatch: 'provisioningState'
                    formatter: 18
                    formatOptions: {
                      thresholdsOptions: 'icons'
                      thresholdsGrid: [
                        {
                          operator: '=='
                          thresholdValue: 'Succeeded'
                          representation: 'success'
                          text: '{0}{1}'
                        }
                        {
                          operator: 'Default'
                          thresholdValue: null
                          representation: 'warning'
                          text: '{0}{1}'
                        }
                      ]
                    }
                  }
                ]
                filter: true
                labelSettings: [
                  {
                    columnId: 'datastoreName'
                    label: 'Datastore Name'
                  }
                  {
                    columnId: 'pcName'
                    label: 'Private Cloud'
                  }
                  {
                    columnId: 'clusterName'
                    label: 'Cluster'
                  }
                  {
                    columnId: 'datastoreType'
                    label: 'Type'
                  }
                  {
                    columnId: 'status'
                    label: 'Status'
                  }
                  {
                    columnId: 'provisioningState'
                    label: 'Provisioning'
                  }
                ]
              }
            }
            customWidth: '50'
            name: 'query - datastore-inventory'
          }
          {
            type: 3
            content: {
              version: 'KqlItem/1.0'
              query: 'resources\r\n| where type == "microsoft.avs/privateclouds" or type == "microsoft.avs/privateclouds/clusters"\r\n| extend pcName = iff(type == "microsoft.avs/privateclouds", name, tostring(split(id, "/")[8]))\r\n| extend clusterName = iff(type == "microsoft.avs/privateclouds", "Management", name)\r\n| extend clusterSize = iff(type == "microsoft.avs/privateclouds", toint(properties.managementCluster.clusterSize), toint(properties.clusterSize))\r\n| extend hosts = iff(type == "microsoft.avs/privateclouds", properties.managementCluster.hosts, properties.hosts)\r\n| extend hostCount = array_length(hosts)\r\n| extend provisioningState = tostring(properties.provisioningState)\r\n| project clusterName, pcName, clusterSize, hostCount, provisioningState, resourceGroup'
              size: 0
              title: 'Clusters (Storage Hosts)'
              noDataMessage: 'No clusters found - Clusters provide the compute and vSAN storage capacity'
              showRefreshButton: true
              showExportToExcel: true
              queryType: 1
              resourceType: 'microsoft.resourcegraph/resources'
              crossComponentResources: [
                '{Subscription}'
              ]
              visualization: 'table'
              gridSettings: {
                formatters: [
                  {
                    columnMatch: 'clusterSize'
                    formatter: 4
                    formatOptions: {
                      palette: 'blue'
                      min: 3
                      max: 16
                    }
                  }
                  {
                    columnMatch: 'provisioningState'
                    formatter: 18
                    formatOptions: {
                      thresholdsOptions: 'icons'
                      thresholdsGrid: [
                        {
                          operator: '=='
                          thresholdValue: 'Succeeded'
                          representation: 'success'
                          text: '{0}{1}'
                        }
                        {
                          operator: 'Default'
                          thresholdValue: null
                          representation: 'warning'
                          text: '{0}{1}'
                        }
                      ]
                    }
                  }
                ]
                filter: true
                labelSettings: [
                  {
                    columnId: 'clusterName'
                    label: 'Cluster Name'
                  }
                  {
                    columnId: 'pcName'
                    label: 'Private Cloud'
                  }
                  {
                    columnId: 'clusterSize'
                    label: 'Cluster Size'
                  }
                  {
                    columnId: 'hostCount'
                    label: 'Host Count'
                  }
                  {
                    columnId: 'provisioningState'
                    label: 'Status'
                  }
                ]
              }
            }
            customWidth: '50'
            name: 'query - clusters-storage'
          }
        ]
      }
      conditionalVisibility: {
        parameterName: 'Tab'
        comparison: 'isEqualTo'
        value: 'Storage'
      }
      name: 'Group - Storage'
    }
    {
      type: 12
      content: {
        version: 'NotebookGroup/1.0'
        groupType: 'editable'
        items: [
          {
            type: 1
            content: {
              json: '## Azure Arc Integration\r\nThis tab shows Arc-enabled VMware vSphere resources including VMs with guest management enabled and Azure extension status.'
            }
            name: 'text - arc-header'
          }
          {
            type: 3
            content: {
              version: 'KqlItem/1.0'
              query: 'resources\r\n| where type == "microsoft.connectedvmwarevsphere/virtualmachines"\r\n| extend guestAgentStatus = tostring(properties.guestAgentProfile.status)\r\n| extend vmToolsStatus = tostring(properties.osProfile.toolsRunningStatus)\r\n| extend osType = tostring(properties.osProfile.osType)\r\n| extend osName = tostring(properties.osProfile.osName)\r\n| summarize GuestManaged = countif(guestAgentStatus == "Connected"), NotManaged = countif(guestAgentStatus != "Connected" or isempty(guestAgentStatus))'
              size: 4
              title: 'Guest Management Status'
              noDataMessage: 'No Arc-enabled VMware VMs found - Enable Azure Arc for VMware vSphere to track guest management status'
              queryType: 1
              resourceType: 'microsoft.resourcegraph/resources'
              crossComponentResources: [
                '{Subscription}'
              ]
              visualization: 'tiles'
              tileSettings: {
                titleContent: {
                  columnMatch: 'GuestManaged'
                  formatter: 1
                }
                showBorder: false
              }
            }
            customWidth: '50'
            name: 'query - guest-summary'
          }
          {
            type: 3
            content: {
              version: 'KqlItem/1.0'
              query: 'resources\r\n| where type == "microsoft.connectedvmwarevsphere/virtualmachines"\r\n| extend osType = tostring(properties.osProfile.osType)\r\n| summarize count() by osType'
              size: 4
              title: 'VMs by OS Type'
              noDataMessage: 'No Arc-enabled VMware VMs found to show OS type distribution'
              queryType: 1
              resourceType: 'microsoft.resourcegraph/resources'
              crossComponentResources: [
                '{Subscription}'
              ]
              visualization: 'piechart'
            }
            customWidth: '50'
            name: 'query - os-distribution'
          }
          {
            type: 3
            content: {
              version: 'KqlItem/1.0'
              query: 'resources\r\n| where type == "microsoft.connectedvmwarevsphere/virtualmachines/extensions" or type == "microsoft.hybridcompute/machines/extensions"\r\n| extend vmId = tostring(split(id, "/extensions")[0])\r\n| extend extensionType = tostring(properties.type)\r\n| extend provisioningState = tostring(properties.provisioningState)\r\n| extend publisher = tostring(properties.publisher)\r\n| project name, vmId, extensionType, publisher, provisioningState, resourceGroup'
              size: 0
              title: 'Azure Extensions on Arc-Enabled VMs'
              noDataMessage: 'No Azure extensions deployed on Arc-enabled VMs - Deploy extensions like Azure Monitor Agent (AMA) or Microsoft Defender for enhanced management'
              showRefreshButton: true
              showExportToExcel: true
              queryType: 1
              resourceType: 'microsoft.resourcegraph/resources'
              crossComponentResources: [
                '{Subscription}'
              ]
              visualization: 'table'
              gridSettings: {
                formatters: [
                  {
                    columnMatch: 'provisioningState'
                    formatter: 18
                    formatOptions: {
                      thresholdsOptions: 'icons'
                      thresholdsGrid: [
                        {
                          operator: '=='
                          thresholdValue: 'Succeeded'
                          representation: 'success'
                          text: '{0}{1}'
                        }
                        {
                          operator: '=='
                          thresholdValue: 'Failed'
                          representation: 'failed'
                          text: '{0}{1}'
                        }
                        {
                          operator: 'Default'
                          thresholdValue: null
                          representation: 'pending'
                          text: '{0}{1}'
                        }
                      ]
                    }
                  }
                ]
                filter: true
                labelSettings: [
                  {
                    columnId: 'name'
                    label: 'Extension'
                  }
                  {
                    columnId: 'vmId'
                    label: 'VM'
                  }
                  {
                    columnId: 'extensionType'
                    label: 'Type'
                  }
                  {
                    columnId: 'publisher'
                    label: 'Publisher'
                  }
                  {
                    columnId: 'provisioningState'
                    label: 'Status'
                  }
                ]
              }
            }
            name: 'query - extensions'
          }
          {
            type: 3
            content: {
              version: 'KqlItem/1.0'
              query: 'resources\r\n| where type == "microsoft.connectedvmwarevsphere/virtualmachines"\r\n| extend guestAgentStatus = tostring(properties.guestAgentProfile.status)\r\n| extend vmToolsStatus = tostring(properties.osProfile.toolsRunningStatus)\r\n| extend osType = tostring(properties.osProfile.osType)\r\n| extend osName = tostring(properties.osProfile.osName)\r\n| extend powerState = tostring(properties.powerState)\r\n| project name, resourceGroup, osType, osName, guestAgentStatus, vmToolsStatus, powerState'
              size: 0
              title: 'Arc-Enabled VM Details'
              noDataMessage: 'No Arc-enabled VMware VMs found - Enable Azure Arc for VMware vSphere to manage VMs from Azure'
              showRefreshButton: true
              showExportToExcel: true
              queryType: 1
              resourceType: 'microsoft.resourcegraph/resources'
              crossComponentResources: [
                '{Subscription}'
              ]
              visualization: 'table'
              gridSettings: {
                formatters: [
                  {
                    columnMatch: 'guestAgentStatus'
                    formatter: 18
                    formatOptions: {
                      thresholdsOptions: 'icons'
                      thresholdsGrid: [
                        {
                          operator: '=='
                          thresholdValue: 'Connected'
                          representation: 'success'
                          text: '{0}{1}'
                        }
                        {
                          operator: 'Default'
                          thresholdValue: null
                          representation: 'warning'
                          text: '{0}{1}'
                        }
                      ]
                    }
                  }
                  {
                    columnMatch: 'vmToolsStatus'
                    formatter: 18
                    formatOptions: {
                      thresholdsOptions: 'icons'
                      thresholdsGrid: [
                        {
                          operator: '=='
                          thresholdValue: 'guestToolsRunning'
                          representation: 'success'
                          text: '{0}{1}'
                        }
                        {
                          operator: 'Default'
                          thresholdValue: null
                          representation: 'warning'
                          text: '{0}{1}'
                        }
                      ]
                    }
                  }
                  {
                    columnMatch: 'powerState'
                    formatter: 18
                    formatOptions: {
                      thresholdsOptions: 'icons'
                      thresholdsGrid: [
                        {
                          operator: '=='
                          thresholdValue: 'poweredOn'
                          representation: 'success'
                          text: ''
                        }
                        {
                          operator: 'Default'
                          thresholdValue: null
                          representation: 'stopped'
                          text: ''
                        }
                      ]
                    }
                  }
                ]
                filter: true
                labelSettings: [
                  {
                    columnId: 'name'
                    label: 'VM Name'
                  }
                  {
                    columnId: 'osType'
                    label: 'OS'
                  }
                  {
                    columnId: 'osName'
                    label: 'OS Version'
                  }
                  {
                    columnId: 'guestAgentStatus'
                    label: 'Guest Agent'
                  }
                  {
                    columnId: 'vmToolsStatus'
                    label: 'VM Tools'
                  }
                  {
                    columnId: 'powerState'
                    label: 'Power'
                  }
                ]
              }
            }
            name: 'query - arc-vms-detail'
          }
        ]
      }
      conditionalVisibility: {
        parameterName: 'Tab'
        comparison: 'isEqualTo'
        value: 'Resources'
      }
      name: 'Group - Arc'
    }
    {
      type: 12
      content: {
        version: 'NotebookGroup/1.0'
        groupType: 'editable'
        items: [
          {
            type: 1
            content: {
              json: '## Capacity & Cost Planning\r\nThis tab provides insights into AVS capacity utilization and helps with cost planning based on SKU and host counts.'
            }
            name: 'text - capacity-header'
          }
          {
            type: 3
            content: {
              version: 'KqlItem/1.0'
              query: 'resources\r\n| where type == "microsoft.avs/privateclouds"\r\n| extend skuName = tostring(sku.name)\r\n| extend clusterSize = toint(properties.managementCluster.clusterSize)\r\n| extend availability = tostring(properties.availability.strategy)\r\n| summarize TotalHosts = sum(clusterSize) by skuName'
              size: 4
              title: 'Total Hosts by SKU'
              queryType: 1
              resourceType: 'microsoft.resourcegraph/resources'
              crossComponentResources: [
                '{Subscription}'
              ]
              visualization: 'tiles'
              tileSettings: {
                showBorder: false
                titleContent: {
                  columnMatch: 'skuName'
                  formatter: 1
                }
                leftContent: {
                  columnMatch: 'TotalHosts'
                  formatter: 12
                  formatOptions: {
                    palette: 'auto'
                  }
                  numberFormat: {
                    unit: 17
                    options: {
                      maximumSignificantDigits: 3
                      maximumFractionDigits: 2
                    }
                  }
                }
              }
            }
            customWidth: '50'
            name: 'query - hosts-by-sku'
          }
          {
            type: 3
            content: {
              version: 'KqlItem/1.0'
              query: 'resources\r\n| where type == "microsoft.avs/privateclouds"\r\n| extend availability = tostring(properties.availability.strategy)\r\n| summarize count() by availability'
              size: 4
              title: 'Availability Strategy Distribution'
              queryType: 1
              resourceType: 'microsoft.resourcegraph/resources'
              crossComponentResources: [
                '{Subscription}'
              ]
              visualization: 'piechart'
            }
            customWidth: '50'
            name: 'query - availability-dist'
          }
          {
            type: 3
            content: {
              version: 'KqlItem/1.0'
              query: 'resources\r\n| where type == "microsoft.avs/privateclouds/clusters" or type == "microsoft.avs/privateclouds"\r\n| extend pcName = iff(type == "microsoft.avs/privateclouds", name, tostring(split(id, "/")[8]))\r\n| extend clusterName = iff(type == "microsoft.avs/privateclouds", "Management", name)\r\n| extend hosts = iff(type == "microsoft.avs/privateclouds", properties.managementCluster.hosts, properties.hosts)\r\n| extend clusterSize = iff(type == "microsoft.avs/privateclouds", toint(properties.managementCluster.clusterSize), toint(properties.clusterSize))\r\n| extend skuName = tostring(sku.name)\r\n| project pcName, clusterName, clusterSize, skuName, location, resourceGroup'
              size: 0
              title: 'Cluster Details'
              showRefreshButton: true
              showExportToExcel: true
              queryType: 1
              resourceType: 'microsoft.resourcegraph/resources'
              crossComponentResources: [
                '{Subscription}'
              ]
              visualization: 'table'
              gridSettings: {
                formatters: [
                  {
                    columnMatch: 'clusterSize'
                    formatter: 4
                    formatOptions: {
                      palette: 'blue'
                    }
                  }
                  {
                    columnMatch: 'skuName'
                    formatter: 18
                    formatOptions: {
                      thresholdsOptions: 'colors'
                      thresholdsGrid: [
                        {
                          operator: 'contains'
                          thresholdValue: 'AV36P'
                          representation: 'purple'
                          text: '{0}{1}'
                        }
                        {
                          operator: 'contains'
                          thresholdValue: 'AV36'
                          representation: 'blue'
                          text: '{0}{1}'
                        }
                        {
                          operator: 'contains'
                          thresholdValue: 'AV52'
                          representation: 'green'
                          text: '{0}{1}'
                        }
                        {
                          operator: 'contains'
                          thresholdValue: 'AV64'
                          representation: 'orange'
                          text: '{0}{1}'
                        }
                        {
                          operator: 'Default'
                          thresholdValue: null
                          representation: 'gray'
                          text: '{0}{1}'
                        }
                      ]
                    }
                  }
                ]
                filter: true
                labelSettings: [
                  {
                    columnId: 'pcName'
                    label: 'Private Cloud'
                  }
                  {
                    columnId: 'clusterName'
                    label: 'Cluster'
                  }
                  {
                    columnId: 'clusterSize'
                    label: 'Host Count'
                  }
                  {
                    columnId: 'skuName'
                    label: 'SKU'
                  }
                ]
              }
            }
            name: 'query - cluster-details'
          }
          {
            type: 1
            content: {
              json: '### SKU Reference\r\n| SKU | vCPU | Memory | vSAN Storage | Use Case |\r\n|-----|------|--------|--------------|----------|\r\n| AV36 | 36 cores | 576 GB | 15.4 TB | General purpose |\r\n| AV36P | 36 cores | 768 GB | 19.2 TB | Memory-intensive |\r\n| AV52 | 52 cores | 1.5 TB | 38.4 TB | High performance |\r\n| AV64 | 64 cores | 1 TB | 30.7 TB | Balanced |\r\n\r\n*Note: Minimum 3 hosts per cluster, maximum 16 hosts per cluster*'
            }
            name: 'text - sku-reference'
          }
        ]
      }
      conditionalVisibility: {
        parameterName: 'Tab'
        comparison: 'isEqualTo'
        value: 'Overview'
      }
      name: 'Group - Capacity'
    }
  ]
  isLocked: false
  fallbackResourceIds: [
    'Azure Monitor'
  ]
}

resource workbookId_resource 'microsoft.insights/workbooks@2021-03-08' = {
  name: workbookId
  location: Location
  kind: 'shared'
  properties: {
    displayName: WorkbookDisplayName
    serializedData: string(workbookContent)
    version: '1.0'
    sourceId: 'Azure Monitor'
    category: 'workbook'
  }
  dependsOn: []
  tags: tags
}

output workbookId string = workbookId_resource.id
