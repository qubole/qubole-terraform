data "azurerm_subscription" "current" {
}

provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "=2.0.0"
  subscription_id = ""
  features {}
}

resource "random_id" "deployment_suffix" {
  byte_length = 4
}

module "account_integration" {
  source = "./modules/account_integration"
  deployment_suffix = random_id.deployment_suffix.hex
  subscription_id = data.azurerm_subscription.current.subscription_id
  directory_tenant_id = data.azurerm_subscription.current.tenant_id
  qubole_resource_group_location = "East US"
}

module "network_infrastructure" {
  source = "./modules/network_infrastucture"
  deployment_suffix = random_id.deployment_suffix.hex
  qubole_resource_group_location = module.account_integration.qubole_resource_group_location
  qubole_resource_group_name = module.account_integration.qubole_resource_group_name
  bastion_vm_size = "Standard_DS1_v2"
  public_ssh_key = ""
  qubole_public_key = ""
}

output "qubole_compute_client_id" {
  value = module.account_integration.qubole_azure_ad_application_id
}

output "qubole_compute_tenant_id" {
  value = module.account_integration.qubole_azure_ad_directory_id
}

output "qubole_compute_subscription_id" {
  value = data.azurerm_subscription.current.subscription_id
}

output "application_password" {
  value = module.account_integration.application_password
}

output "service_principal_password" {
  value = module.account_integration.service_principal_password
}

output "qubole_storage_account_name" {
  value = module.account_integration.qubole_dedicated_storage_account_name
}

output "qubole_storage_access_key" {
  value = module.account_integration.qubole_dedicated_storage_account_key_primary
}

output "qubole_default_resource_group" {
  value = module.account_integration.qubole_resource_group_name
}

output "qubole_default_location" {
  value = "${module.account_integration.qubole_defloc}@${module.account_integration.qubole_dedicated_storage_account_name}.blob.core.windows.net"
}



output "qubole_dedicated_storage_account_key_secondary" {
  value = module.account_integration.qubole_dedicated_storage_account_key_secondary
}

output "qubole_bastion_host_public_ip" {
  value = module.network_infrastructure.qubole_bastion_host_public_ip
}

output "qubole_bastion_host_user_name" {
  value = module.network_infrastructure.bastion_host_user_name
}

output "qubole_dedicated_vnet" {
  value = module.network_infrastructure.qubole_dedicated_vnet
}


