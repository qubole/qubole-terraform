resource "azurerm_virtual_network" "qubole_dedicated_vnet" {
  name          = "qubole_dedicated_vnet_${var.deployment_suffix}"
  address_space = ["10.0.0.0/16"]
  location      = var.qubole_resource_group_location

  subnet {
    address_prefix = "10.0.1.0/24"
    name = "qubole_vpc_default_subnet_${var.deployment_suffix}"
  }

  resource_group_name = var.qubole_resource_group_name
}

output "qubole_dedicated_vnet" {
  value = azurerm_virtual_network.qubole_dedicated_vnet.name
}