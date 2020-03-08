resource "azurerm_network_interface" "qubole_vnet_nic" {
  name                = "qubole_vnet_nic_${var.deployment_suffix}"
  location            = var.qubole_resource_group_location
  resource_group_name = var.qubole_resource_group_name

  depends_on = [azurerm_subnet.qubole_vnet_public_subnetwork]

  ip_configuration {
    name                          = "external"
    subnet_id                     = azurerm_subnet.qubole_vnet_public_subnetwork.id
    public_ip_address_id = azurerm_public_ip.qubole_bastion_host_public_ip.id
    private_ip_address_allocation = "Static"
    private_ip_address = "10.0.2.10"
  }
}
