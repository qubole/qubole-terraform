resource "azurerm_network_security_group" "qubole_priv_subnet_security_group" {
  name = "qubole_priv_subnet_security_group_${var.deployment_suffix}"
  location = var.qubole_resource_group_location
  resource_group_name = var.qubole_resource_group_name

  tags = {
    environment = "qubole_tf_deployed_${var.deployment_suffix}"
  }
}

resource "azurerm_network_security_rule" "qubole_bastion_ingress_all" {
  name = "qubole_bastion_ingress_all"
  priority = 103
  direction = "Inbound"
  access = "Allow"
  protocol = "*"
  source_port_range = "*"
  destination_port_range = "*"
  source_address_prefix = azurerm_network_interface.qubole_vnet_nic.private_ip_address
  destination_address_prefix = "*"
  resource_group_name = var.qubole_resource_group_name
  network_security_group_name = azurerm_network_security_group.qubole_priv_subnet_security_group.name
}

resource "azurerm_network_security_rule" "qubole_priv_subnet_internal_all" {
  name                        = "qubole_priv_subnet_internal_all"
  priority                    = 104
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = azurerm_subnet.qubole_vnet_private_subnetwork.address_prefix
  destination_address_prefix  = "*"
  resource_group_name = var.qubole_resource_group_name
  network_security_group_name = azurerm_network_security_group.qubole_priv_subnet_security_group.name
}

resource "azurerm_subnet_network_security_group_association" "nsg_priv_subnet_security_group_assoc" {
  subnet_id                 = azurerm_subnet.qubole_vnet_private_subnetwork.id
  network_security_group_id = azurerm_network_security_group.qubole_priv_subnet_security_group.id
}