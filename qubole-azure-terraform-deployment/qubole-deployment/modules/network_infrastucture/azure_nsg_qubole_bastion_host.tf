resource "azurerm_network_security_group" "bastion_security_group" {
  name = "bastion_security_group_${var.deployment_suffix}"
  location = var.qubole_resource_group_location
  resource_group_name = var.qubole_resource_group_name

  tags = {
    environment = "qubole_tf_deployed_${var.deployment_suffix}"
  }
}

resource "azurerm_network_security_rule" "qubole_tunnel_ingress_ssh" {
  name = "qubole_tunnel_ingress_ssh"
  priority = 100
  direction = "Inbound"
  access = "Allow"
  protocol = "Tcp"
  source_port_range = "22"
  destination_port_range = "*"
  source_address_prefixes = [
    "54.164.240.44",
    "52.23.20.1",
    "40.121.60.130",
    "40.114.27.47",
    "13.82.198.90"]
  destination_address_prefix = azurerm_public_ip.qubole_bastion_host_public_ip.ip_address
  resource_group_name = var.qubole_resource_group_name
  network_security_group_name = azurerm_network_security_group.bastion_security_group.name
}

resource "azurerm_network_security_rule" "qubole_tunnel_reverse_tunnel" {
  name                        = "qubole_tunnel_reverse_tunnel"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "7000"
  destination_port_range      = "*"
  source_address_prefix       = azurerm_subnet.qubole_vnet_private_subnetwork.address_prefix
  destination_address_prefix  = azurerm_network_interface.qubole_vnet_nic.private_ip_address
  resource_group_name = var.qubole_resource_group_name
  network_security_group_name = azurerm_network_security_group.bastion_security_group.name
}