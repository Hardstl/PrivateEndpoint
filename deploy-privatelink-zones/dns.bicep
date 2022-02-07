param privateLinkZones array
param vnetLinks array = []

resource dnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = [for zone in privateLinkZones: {
  name: zone
  location: 'global'
}]

module virtualNetworkLinks 'modules/virtualNetworkLinks.bicep' = [for (zone, i) in privateLinkZones: {
  name: '${zone}-vnetlink${i}-deploy'
  params: {
    vnetLinks: vnetLinks
    privateLinkZone: zone
  }
}]
