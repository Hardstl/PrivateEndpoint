// ---------------[Initialisations]----------
targetScope = 'managementGroup'


// ---------------[PARAMETERS]---------------
param location string

param privateLinkZonesSubscriptionId string
param privateLinkZonesResourceGroup string

param policyInitiativeName string


// ---------------[VARIABLES]----------------
var privateLinkZonesLocation = '/subscriptions/${privateLinkZonesSubscriptionId}/resourceGroups/${privateLinkZonesResourceGroup}/providers/Microsoft.Network/privateDnsZones'

var policySettings = [
  {
    name: 'Automation Webhook'
    value: 'Webhook'
    zone: 'privatelink.azure-automation.net'
  }
  {
    name: 'Automation DSCAndHybridWorker'
    value: 'DSCAndHybridWorker'
    zone: 'privatelink.azure-automation.net'
  }
  {
    name: 'Sql Server'
    value: 'sqlServer'
    zone: 'privatelink.database.windows.net'
  }
  {
    name: 'Synapse Sql'
    value: 'sql'
    zone: 'privatelink.sql.azuresynapse.net'
  }
  {
    name: 'Synapse Sql On Demand'
    value: 'sqlOnDemand'
    zone: 'privatelink.sql.azuresynapse.net'
  }
  {
    name: 'Synapse Dev'
    value: 'dev'
    zone: 'privatelink.dev.azuresynapse.net'
  }
  {
    name: 'Synapse Studio'
    value: 'web'
    zone: 'privatelink.azuresynapse.net'
  }
  {
    name: 'Storage Blob'
    value: 'blob'
    zone: 'privatelink.blob.core.windows.net'
  }
  {
    name: 'Storage Table'
    value: 'table'
    zone: 'privatelink.table.core.windows.net'
  }
  {
    name: 'Storage Queue'
    value: 'queue'
    zone: 'privatelink.queue.core.windows.net'
  }
  {
    name: 'Storage File'
    value: 'file'
    zone: 'privatelink.file.core.windows.net'
  }
  {
    name: 'Storage Web'
    value: 'web'
    zone: 'privatelink.web.core.windows.net'
  }
  {
    name: 'Data Lake File System'
    value: 'dfs'
    zone: 'privatelink.dfs.core.windows.net'
  }
  {
    name: 'Cosmos Sql'
    value: 'sql'
    zone: 'privatelink.documents.azure.com'
  }
  {
    name: 'Cosmos MongoDB'
    value: 'MongoDB'
    zone: 'privatelink.mongo.cosmos.azure.com'
  }
  {
    name: 'Cosmos Cassandra'
    value: 'Cassandra'
    zone: 'privatelink.cassandra.cosmos.azure.com'
  }
  {
    name: 'Cosmos Gremlin'
    value: 'Gremlin'
    zone: 'privatelink.gremlin.cosmos.azure.com'
  }
  {
    name: 'Cosmos Table'
    value: 'Table'
    zone: 'privatelink.table.cosmos.azure.com'
  }
  {
    name: 'PostgreSQL'
    value: 'postgresqlServer'
    zone: 'privatelink.postgres.database.azure.com'
  }
  {
    name: 'MySQL'
    value: 'mysqlServer'
    zone: 'privatelink.mysql.database.azure.com'
  }
  {
    name: 'MariaDB'
    value: 'mariadbServer'
    zone: 'privatelink.mariadb.database.azure.com'
  }
  {
    name: 'Key Vault'
    value: 'vault'
    zone: 'privatelink.vaultcore.azure.net'
  }
  {
    name: 'Azure Search'
    value: 'searchService'
    zone: 'privatelink.search.windows.net'
  }
  {
    name: 'Container Registry'
    value: 'registry'
    zone: 'privatelink.azurecr.io'
  }
  {
    name: 'App Configuration'
    value: 'configurationStores'
    zone: 'privatelink.azconfig.io'
  }
  {
    name: 'Event Hubs'
    value: 'namespace'
    zone: 'privatelink.servicebus.windows.net'
  }
  {
    name: 'Service Bus'
    value: 'namespace'
    zone: 'privatelink.servicebus.windows.net'
  }
  {
    name: 'IoT Hub Devices'
    value: 'iotHub'
    zone: 'privatelink.azure-devices.net'
  }
  {
    name: 'IoT Hub Servicebus'
    value: 'iotHub'
    zone: 'privatelink.servicebus.windows.net'
  }
  {
    name: 'Relay'
    value: 'namespace'
    zone: 'privatelink.servicebus.windows.net'
  }
  {
    name: 'Event Grid Topic'
    value: 'topic'
    zone: 'privatelink.eventgrid.azure.net'
  }
  {
    name: 'Event Grid Domain'
    value: 'domain'
    zone: 'privatelink.eventgrid.azure.net'
  }
  {
    name: 'Web Apps'
    value: 'sites'
    zone: 'privatelink.azurewebsites.net'
  }
  {
    name: 'Machine Learning API'
    value: 'amlworkspace'
    zone: 'privatelink.api.azureml.ms'
  }
  {
    name: 'Machine Learning Notebook'
    value: 'amlworkspace'
    zone: 'privatelink.notebooks.azure.net'
  }
  {
    name: 'SignalR'
    value: 'signalR'
    zone: 'privatelink.service.signalr.net'
  }
  {
    name: 'Monitor'
    value: 'azuremonitor'
    zone: 'privatelink.monitor.azure.com'
  }
  {
    name: 'Monitor OMS'
    value: 'azuremonitor'
    zone: 'privatelink.oms.opinsights.azure.com'
  }
  {
    name: 'Monitor ODS'
    value: 'azuremonitor'
    zone: 'privatelink.ods.opinsights.azure.com'
  }
  {
    name: 'Monitor AgentSvc'
    value: 'azuremonitor'
    zone: 'privatelink.agentsvc.azure-automation.net'
  }
  {
    name: 'Monitor Blob'
    value: 'azuremonitor'
    zone: 'privatelink.blob.core.windows.net'
  }
  {
    name: 'Cognitive Services'
    value: 'account'
    zone: 'privatelink.cognitiveservices.azure.com'
  }
  {
    name: 'Azure File Sync'
    value: 'afs'
    zone: 'privatelink.afs.azure.net'
  }
  {
    name: 'Data Factory'
    value: 'dataFactory'
    zone: 'privatelink.datafactory.azure.net'
  }
  {
    name: 'Cache for Redis'
    value: 'redisCache'
    zone: 'privatelink.redis.cache.windows.net'
  }
  {
    name: 'Cache for Redis Enterprise'
    value: 'redisCache'
    zone: 'privatelink.redisenterprise.cache.azure.net'
  }
  {
    name: 'Purview Account'
    value: 'account'
    zone: 'privatelink.purview.azure.com'
  }
  {
    name: 'Purview Portal'
    value: 'portal'
    zone: 'privatelink.purviewstudio.azure.com'
  }
  {
    name: 'Digital Twins'
    value: 'digitalTwinsInstances'
    zone: 'privatelink.digitaltwins.azure.net'
  }
  {
    name: 'HDInsights'
    value: 'cluster'
    zone: 'privatelink.azurehdinsight.net'
  }
]


// ---------------[RESOURCES]----------------
resource policyDefinition 'Microsoft.Authorization/policyDefinitions@2020-09-01' = [for subresource in policySettings: {
  name: replace('DeployDNSFor${subresource.name}', ' ', '')
  properties: {
    displayName: 'Deploy DNS for ${subresource.name}'
    policyType: 'Custom'
    mode: 'All'
    metadata: {
      category: 'Custom'
      source: 'Bicep'
      version: '0.1.0'
    }
    parameters: {
      privateDnsZoneId: {
        type: 'String'
        metadata: {
          displayName: 'privateDnsZoneId'
          strongType: 'Microsoft.Network/privateDnsZones'
        }
      }
    }
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.Network/privateEndpoints'
          }
          {
            count: {
              field: 'Microsoft.Network/privateEndpoints/privateLinkServiceConnections[*].groupIds[*]'
              where: {
                field: 'Microsoft.Network/privateEndpoints/privateLinkServiceConnections[*].groupIds[*]'
                equals: subresource.value
              }
            }
            greaterOrEquals: 1
          }
        ]
      }
      then: {
        effect: 'deployIfNotExists'
        details: {
          roleDefinitionIds: [
            '/providers/Microsoft.Authorization/roleDefinitions/4d97b98b-1d4f-4787-a291-c67834d212e7'
          ]
          type: 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups'
          deployment: {
            properties: {
              mode: 'Incremental'
              template: {
                '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
                contentVersion: '1.0.0.0'
                parameters: {
                  privateDnsZoneId: {
                    type: 'String'
                  }
                  privateEndpointName: {
                    type: 'String'
                  }
                  location: {
                    type: 'String'
                  }
                }
                resources: [
                  {
                    name: '[concat(parameters(\'privateEndpointName\'), \'/deployedByPolicy\')]'
                    type: 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups'
                    apiVersion: '2020-03-01'
                    location: location
                    properties: {
                      privateDnsZoneConfigs: [
                        {
                          name: replace('${subresource.name}-privateDnsZone', ' ', '')
                          properties: {
                            privateDnsZoneId: '${privateLinkZonesLocation}/${subresource.zone}'
                          }
                        }
                      ]
                    }
                  }
                ]
              }
              parameters: {
                privateDnsZoneId: {
                  value: '[parameters(\'privateDnsZoneId\')]'
                }
                privateEndpointName: {
                  value: '[field(\'name\')]'
                }
                location: {
                  value: '[field(\'location\')]'
                }
              }
            }
          }
        }
      }
    }
  }
}]

resource policyInitiative 'Microsoft.Authorization/policySetDefinitions@2020-09-01' = {
  name: policyInitiativeName
  properties: {
    policyType: 'Custom'
    displayName: policyInitiativeName
    metadata: {
      category: 'Custom'
      source: 'Test'
      version: '0.1.0'
    }
    policyDefinitions: [for (subresource, i) in policySettings: {
        policyDefinitionId: policyDefinition[i].id
        policyDefinitionReferenceId: replace('${subresource.name}', ' ', '')
        parameters: {
          privateDnsZoneId: {
            value: '${privateLinkZonesLocation}/${subresource.zone}'
          }
        }
      }]
  }
}
