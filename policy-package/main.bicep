// ---------------[INITIALISATIONS]----------
targetScope = 'managementGroup'

// ---------------[PARAMETERS]---------------
param location string = deployment().location

@description('Provide id of subscription where the privatelink DNS zones are located.')
param privateLinkZonesSubscriptionId string

@description('Provide name of the resource group where the privatelink DNS zones are located.')
param privateLinkZonesResourceGroup string

@description('Define a name for your policy initiative.')
param policyInitiativeName string

// ---------------[VARIABLES]----------------
var privateLinkZonesLocation = '/subscriptions/${privateLinkZonesSubscriptionId}/resourceGroups/${privateLinkZonesResourceGroup}/providers/Microsoft.Network/privateDnsZones'
var policyDefinitionSettings = json(loadTextContent('policyDefinitionSettings.json'))

// ---------------[RESOURCES]----------------
resource policyDefinition 'Microsoft.Authorization/policyDefinitions@2021-06-01' = [for subresource in policyDefinitionSettings: {
  name: replace('DeployDNSFor${subresource.name}', ' ', '')
  properties: {
    displayName: 'Deploy DNS for ${subresource.name}'
    policyType: 'Custom'
    mode: 'All'
    metadata: {
      category: 'Custom'
      source: 'Bicep'
      version: '0.2.0'
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
            field: 'Microsoft.Network/privateEndpoints/privateLinkServiceConnections[*].privateLinkServiceId'
            contains: subresource.type
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

resource policyInitiative 'Microsoft.Authorization/policySetDefinitions@2021-06-01' = {
  name: policyInitiativeName
  properties: {
    policyType: 'Custom'
    displayName: policyInitiativeName
    metadata: {
      category: 'Custom'
      source: 'Test'
      version: '0.1.0'
    }
    policyDefinitions: [for (subresource, i) in policyDefinitionSettings: {
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
