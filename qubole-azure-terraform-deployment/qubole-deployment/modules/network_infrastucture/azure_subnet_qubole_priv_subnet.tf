resource "azurerm_subnet" "qubole_vnet_private_subnetwork" {
  name                 = "qubole_vnet_private_subnetwork_${var.deployment_suffix}"
  resource_group_name  = var.qubole_resource_group_name
  virtual_network_name = azurerm_virtual_network.qubole_dedicated_vnet.name
  address_prefix       = "10.0.3.0/24"
}
