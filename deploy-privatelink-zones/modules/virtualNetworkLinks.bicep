param privateLinkZone string
param vnetLinks array

resource vnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = [for (link, i) in vnetLinks: {
  name:  '${privateLinkZone}/${link.name}'
  location: 'global'
  properties: {
    registrationEnabled: link.registrationEnabled
    virtualNetwork: {
      id: link.vnetId
    }
  }
}]
