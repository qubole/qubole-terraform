resource "azurerm_storage_account" "qubole_storage_account" {
  name                     = "qubolestorageacc${var.deployment_suffix}"
  resource_group_name      = azurerm_resource_group.qubole_resource_group.name
  location                 = azurerm_resource_group.qubole_resource_group.location
  account_kind = "BlobStorage"
  account_tier             = "Standard"
  account_replication_type = "RAGRS"
  enable_https_traffic_only = false

  depends_on = [azuread_application.qubole_azure_ad_application]

  tags = {
    environment = "qubole_tf_deployed_${var.deployment_suffix}"
  }
}

output "qubole_dedicated_storage_account_name" {
  value = azurerm_storage_account.qubole_storage_account.name
}

output "qubole_dedicated_storage_account_key_primary" {
  value = azurerm_storage_account.qubole_storage_account.primary_access_key
}

output "qubole_dedicated_storage_account_key_secondary" {
  value = azurerm_storage_account.qubole_storage_account.secondary_access_key
}