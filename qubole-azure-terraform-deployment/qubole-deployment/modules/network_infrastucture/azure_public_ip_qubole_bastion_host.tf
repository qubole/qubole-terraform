resource "azurerm_public_ip" "qubole_bastion_host_public_ip" {
  name                = "qubole_bastion_host_public_ip_${var.deployment_suffix}"
  location            = var.qubole_resource_group_location
  resource_group_name = var.qubole_resource_group_name
  allocation_method   = "Static"

  tags = {
    environment = "qubole_tf_deployed_${var.deployment_suffix}"
  }
}

output "qubole_bastion_host_public_ip" {
  value = azurerm_public_ip.qubole_bastion_host_public_ip.ip_address
}