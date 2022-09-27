param privateLinkZones array
param vnetLinks array = []

resource dnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = [for zone in privateLinkZones: {
  name: zone
  location: 'global'
}]

module virtualNetworkLinks 'modules/virtualNetworkLinks.bicep' = [for zone in privateLinkZones: {
  name: 'vnetlink-${zone}'
  dependsOn: [
    dnsZone
  ]
  params: {
    vnetLinks: vnetLinks
    privateLinkZone: zone
  }
}]
