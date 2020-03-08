resource "azurerm_network_security_group" "qubole_pub_subnet_security_group" {
  name = "qubole_pub_subnet_security_group_${var.deployment_suffix}"
  location = var.qubole_resource_group_location
  resource_group_name = var.qubole_resource_group_name

  tags = {
    environment = "qubole_tf_deployed_${var.deployment_suffix}"
  }
}

resource "azurerm_network_security_rule" "qubole_tunnel_ingress_ssh_subnet" {
  name = "qubole_tunnel_ingress_ssh"
  priority = 100
  direction = "Inbound"
  access = "Allow"
  protocol = "Tcp"
  source_port_range = "*"
  destination_port_range = "22"
  #Includes US-SOC addresses
  source_address_prefixes = [
    "54.164.240.44/32",
    "52.23.20.1/32",
    "40.121.60.130/32",
    "40.114.27.47/32",
    "13.82.198.90/32",
    "52.44.223.209/32",
    "100.25.6.193/32"]
  destination_address_prefixes = [azurerm_public_ip.qubole_bastion_host_public_ip.ip_address, azurerm_network_interface.qubole_vnet_nic.private_ip_address]
  resource_group_name = var.qubole_resource_group_name
  network_security_group_name = azurerm_network_security_group.qubole_pub_subnet_security_group.name
}

resource "azurerm_network_security_rule" "qubole_tunnel_reverse_tunnel" {
  name                        = "qubole_tunnel_reverse_tunnel"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "7000"
  source_address_prefix       = azurerm_subnet.qubole_vnet_private_subnetwork.address_prefix
  destination_address_prefix  = azurerm_network_interface.qubole_vnet_nic.private_ip_address
  resource_group_name = var.qubole_resource_group_name
  network_security_group_name = azurerm_network_security_group.qubole_pub_subnet_security_group.name
}

resource "azurerm_subnet_network_security_group_association" "nsg_pub_subnet_security_group_assoc" {
  subnet_id                 = azurerm_subnet.qubole_vnet_public_subnetwork.id
  network_security_group_id = azurerm_network_security_group.qubole_pub_subnet_security_group.id
}

#resource azurerm_network_interface_security_group_association "bastion_nic_nsg_assoc" {
#  network_interface_id      = azurerm_network_interface.qubole_vnet_nic.id
#  network_security_group_id = azurerm_network_security_group.qubole_bastion_nic_security_group.id
#}