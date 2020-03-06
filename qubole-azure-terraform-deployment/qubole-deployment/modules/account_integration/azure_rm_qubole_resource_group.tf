
resource "azurerm_resource_group" "qubole_resource_group" {
  name     = "qubole-resource-group_${var.deployment_suffix}"
  location = var.qubole_resource_group_location

  depends_on = [azuread_application.qubole_azure_ad_application]

  tags = {
    environment = "qubole_tf_deployed_${var.deployment_suffix}"
  }
}