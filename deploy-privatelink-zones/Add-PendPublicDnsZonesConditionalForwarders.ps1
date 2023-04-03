# Create custom DNS partition
Add-DnsServerDirectoryPartition -Name "PrivateEndpoint"

# Add server to partition
Register-DnsServerDirectoryPartition -Name "PrivateEndpoint"

# DNS servers located in Azure
$azureDnsServers = @(
    "10.0.0.5"
)

# Zones to deploy, should match zones in file dns.parameters.json
# For reference: https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-dns
$zones = (
    "azure-automation.net",
    "database.windows.net",
    "sql.azuresynapse.net",
    "dev.azuresynapse.net",
    "azuresynapse.net",
    "blob.core.windows.net",
    "table.core.windows.net",
    "queue.core.windows.net",
    "file.core.windows.net",
    "web.core.windows.net",
    "dfs.core.windows.net",
    "documents.azure.com",
    "mongo.cosmos.azure.com",
    "cassandra.cosmos.azure.com",
    "gremlin.cosmos.azure.com",
    "table.cosmos.azure.com",
    "postgres.database.azure.com",
    "mysql.database.azure.com",
    "mariadb.database.azure.com",
    "vault.azure.net",
    "vaultcore.azure.net",
    "managedhsm.azure.net",
    "search.windows.net",
    "azurecr.io",
    "azconfig.io",
    "servicebus.windows.net",
    "azure-devices.net",
    "azure-devices-provisioning.net",
    "eventgrid.azure.net",
    "azurewebsites.net",
    "scm.azurewebsites.net",
    "api.azureml.ms",
    "notebooks.azure.net",
    "instances.azureml.ms",
    "aznbcontent.net",
    "inference.ml.azure.com",
    "service.signalr.net",
    "cognitiveservices.azure.com",
    "openai.azure.com",
    "datafactory.azure.net",
    "adf.azure.com",
    "redis.cache.windows.net",
    "redisenterprise.cache.azure.net",
    "purview.azure.com",
    "digitaltwins.azure.net",
    "azurehdinsight.net",
    "his.arc.azure.com",
    "guestconfiguration.azure.com",
    "kubernetesconfiguration.azure.com",
    "media.azure.net",
    "azurestaticapps.net",
    "prod.migration.windowsazure.com",
    "azure-api.net",
    "developer.azure-api.net",
    "analysis.windows.net",
    "pbidedicated.windows.net",
    "tip1.powerquery.microsoft.com",
    "directline.botframework.com",
    "europe.directline.botframework.com",
    "token.botframework.com",
    "europe.token.botframework.com",
    "workspace.azurehealthcareapis.com",
    "fhir.azurehealthcareapis.com",
    "dicom.azurehealthcareapis.com",
    "azuredatabricks.net"
)

# Loop through zones and create conditional forwarders pointing to your Azure DNS servers
$zones | foreach {Add-DnsServerConditionalForwarderZone -Name $_ -ReplicationScope Custom -DirectoryPartitionName "PrivateEndpoint" -MasterServers $azureDnsServers}