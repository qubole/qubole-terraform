resource "azurerm_storage_container" "qubole_dedicated_storage_container" {
  name                  = "qubole-defloc-${var.deployment_suffix}"
  storage_account_name  = azurerm_storage_account.qubole_storage_account.name
  container_access_type = "private"
}

output "qubole_defloc" {
  value = azurerm_storage_container.qubole_dedicated_storage_container.name
}