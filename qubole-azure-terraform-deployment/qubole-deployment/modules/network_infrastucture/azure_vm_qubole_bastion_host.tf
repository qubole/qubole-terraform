data "template_file" "qubole_bastion_ssh_bootstrap" {
  template = file("${path.module}/scripts/qubole_bastion_startup.sh")
  vars = {
    public_ssh_key = var.public_ssh_key
    qubole_public_key = var.qubole_public_key
    bastion_user_name = var.bastion_user_name
  }
}

resource "azurerm_virtual_machine" "qubole_bastion_host" {
  name = "qubole_dedicated_bastion_host_${var.deployment_suffix}"
  location = var.qubole_resource_group_location
  resource_group_name = var.qubole_resource_group_name
  network_interface_ids = [
    azurerm_network_interface.qubole_vnet_nic.id]
  vm_size = var.bastion_vm_size

  delete_os_disk_on_termination = true

  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer = "UbuntuServer"
    sku = "16.04-LTS"
    version = "latest"
  }
  storage_os_disk {
    name = "os_disk"
    caching = "ReadWrite"
    create_option = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name = "qubolebastionhost"
    admin_username = var.bastion_user_name
    admin_password = var.bastion_user_password

    custom_data = data.template_file.qubole_bastion_ssh_bootstrap.rendered
  }
  os_profile_linux_config {
    disable_password_authentication = false
    ssh_keys {
      key_data = var.public_ssh_key
      path = "/home/${var.bastion_user_name}/.ssh/authorized_keys"
    }
  }

  tags = {
    environment = "qubole_tf_deployed_${var.deployment_suffix}"
  }
}

output "bastion_host_user_name" {
  value = var.bastion_user_name
}