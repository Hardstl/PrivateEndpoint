# PrivateEndpoint

This repository is to help you get started with deploying and managing Private Endpoints for your Azure resources. Everything is deployed using Bicep.

## What are Private Endpoints?

Private Endpoints connects your existing PaaS services in Azure to a virtual network, allowing other services inside Azure or on-premises to connect to the Private Endpoint enabled services over your private network. Enabling Private Endpoint on a service does not give it outbound connectivity, it only handles inbound.

## Deploy Private Link DNS Zones

To get started you'll first need to deploy all the private DNS zones for the services you require. Remove the zones you don't need from the `deploy-privatelink-zones\dns.parameters.json` file, or deploy them all at once.

- Deploy zones to resource group, replace **ResourceGroupName** with your own

  ```PowerShell
  $Params = @{
      ResourceGroupName = 'central-dns-rg'
      TemplateFile = '.\deploy-privatelink-zones\dns.bicep'
      TemplateParameterFile = '.\deploy-privatelink-zones\dns.parameters.json'
  }

  New-AzResourceGroupDeployment @Params
  ```

### Create links to virtual networks

Once the zones are created you'll need to create virtual network links for each zone to your virtual networks that host services that should be able to resolve the Private Endpoints to their Private IPs. Doing this by hand for each zone can be very time consuming, instead add the required virtual networks in the `deploy-privatelink-zones\dns.parameters.json` file and redeploy every time a new network is in need of the links.

- Give your link a name
- Add the virtual network resource id

  ![DnsVnetLink](./media/dnslink.png)

- Deploy to add virtual network links

  ```PowerShell
  $Params = @{
      ResourceGroupName = 'central-dns-rg'
      TemplateFile = '.\deploy-privatelink-zones\dns.bicep'
      TemplateParameterFile = '.\deploy-privatelink-zones\dns.parameters.json'
  }

  New-AzResourceGroupDeployment @Params
  ```
  
  <br/>
  
  ![DnsVnetLink2](./media/dnslink2.png)

## Manage Private Endpoints using Azure Policy

Now that the zones and links are in place we want an automated and reliable way of creating the DNS records for each Private Endpoint that you enable for your different Azure services. Provided here is a complete policy package that takes care of all the services.

| Parameter | Description |
| --- | --- |
| location | Location can be any Azure location |
| privateLinkZonesSubscriptionId | Subscription id that holds your private DNS zones |
| privateLinkZonesResourceGroup | Resource group that holds your private DNS zones |
| policyInitiativeName | Name of the policy initiative that will be deployed |

<br/>

- Deploy policy package, replace **ManagementGroupId** with your own

  ```PowerShell
  $Params = @{
      ManagementGroupId = 'mg-policy'
      TemplateFile = '.\policy-package\main.bicep'
      TemplateParameterFile = '.\policy-package\main.parameters.json'
      Location = 'westeurope'
  }

  New-AzManagementGroupDeployment @Params
  ```

- Assign your newly created initiative
  - Requires **Network Contributor** on Private Endpoint resources and **Private DNS Zone Contributor** on resource group containing all your zones (Network Contributor does the job)

<br/>

Deployed policies

![PolicyPackage](./media/policy.png)

<br/>

Deployed initiative containing all policies

![PolicyPackage2](./media/initiative.png)

## Multi zone services

Some services require DNS records to be registered to multiple zones. The bicep deployment doesn't currently support creating those policies. Instead, manually create the definitions from the JSON files and add them to the initiative.

| Private link resource type / Subresource | Private DNS zone name | Public DNS zone forwarders | Policy file |
| --- | --- | --- | --- |
| Azure IoT Hub (Microsoft.Devices/IotHubs) / iotHub | privatelink.azure-devices.net <br> privatelink.servicebus.windows.net | azure-devices.net <br> servicebus.windows.net | Deploy-DNSforIoTHub.json |
| Azure Web Apps (Microsoft.Web/sites) / sites | privatelink.azurewebsites.net <br> scm.privatelink.azurewebsites.net | azurewebsites.net <br> scm.azurewebsites.net | Deploy-DNSforSites.json |
| Azure Machine Learning (Microsoft.MachineLearningServices/workspaces) / amlworkspace | privatelink.api.azureml.ms <br> privatelink.notebooks.azure.net | api.azureml.ms <br> notebooks.azure.net <br> instances.azureml.ms <br> aznbcontent.net <br> inference.ml.azure.com | Deploy-DNSforAzureML.json |
| Cognitive Services (Microsoft.CognitiveServices/accounts) / account | privatelink.cognitiveservices.azure.com <br> privatelink.openai.azure.com | cognitiveservices.azure.com <br> openai.azure.com | Deploy-DNSforCognitiveServices.json |
| Azure Arc (Microsoft.HybridCompute) / hybridcompute | privatelink.his.arc.azure.com <br> privatelink.guestconfiguration.azure.com <br> privatelink.kubernetesconfiguration.azure.com | his.arc.azure.com <br> guestconfiguration.azure.com <br> kubernetesconfiguration.azure.com | Deploy-DNSforHybridCompute.json |
| Azure API Management (Microsoft.ApiManagement/service) / gateway | privatelink.azure-api.net <br> privatelink.developer.azure-api.net | azure-api.net <br> developer.azure-api.net | DDeploy-DNSforApiManagement.json |
| Azure Health Data Services (Microsoft.HealthcareApis/workspaces) / healthcareworkspace | privatelink.workspace.azurehealthcareapis.com <br> privatelink.fhir.azurehealthcareapis.com <br> privatelink.dicom.azurehealthcareapis.com | workspace.azurehealthcareapis.com <br> fhir.azurehealthcareapis.com <br> dicom.azurehealthcareapis.com | Deploy-DNSforHealthDataServices.json |

## Services not supported

The below table lists the services not supported in this package.

| Private link resource type / Subresource | Private DNS zone name | Public DNS zone forwarders | Reason |
| --- | --- | --- | --- |
| Azure SQL Managed Instance (Microsoft.Sql/managedInstances) | privatelink.{dnsPrefix}.database.windows.net | {instanceName}.{dnsPrefix}.database.windows.net | Dynamic values |
| Azure Kubernetes Service - Kubernetes API (Microsoft.ContainerService/managedClusters) / management | privatelink.{region}.azmk8s.io <br> {subzone}.privatelink.{region}.azmk8s.io | {region}.azmk8s.io | Regional |
| Azure Backup (Microsoft.RecoveryServices/vaults) / AzureBackup | privatelink.{region}.backup.windowsazure.com | {region}.backup.windowsazure.com | Regional |
| Azure File Sync (Microsoft.StorageSync/storageSyncServices) / afs | {region}.privatelink.afs.azure.net | {region}.afs.azure.net | Regional |
| Azure Data Explorer (Microsoft.Kusto) | privatelink.{region}.kusto.windows.net | {region}.kusto.windows.net | Regional |
| Microsoft PowerBI (Microsoft.PowerBI/privateLinkServicesForPowerBI) | privatelink.analysis.windows.net <br> privatelink.pbidedicated.windows.net <br> privatelink.tip1.powerquery.microsoft.com | analysis.windows.net <br> pbidedicated.windows.net <br> tip1.powerquery.microsoft.com | Unknown subresource value

## Credit

Special thanks to [Stefan](https://github.com/StefanIvemo) and [Simon](https://github.com/SimonWahlin) for all their Bicep knowledge.
