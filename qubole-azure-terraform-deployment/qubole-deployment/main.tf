data "azurerm_subscription" "current" {
}

provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "=2.0.0"
  subscription_id = "79185a58-fe07-437e-bc9a-66be9820c8db"
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

output "qubole_azure_ad_application_id" {
  value = module.account_integration.qubole_azure_ad_application_id
}

output "qubole_azure_ad_directory_id" {
  value = module.account_integration.qubole_azure_ad_directory_id
}

output "subscription_id" {
  value = data.azurerm_subscription.current.subscription_id
}

output "qubole_azure_ad_directory_client_secret" {
  value = module.account_integration.qubole_azure_ad_directory_client_secret
}

output "azuread_service_principal_password" {
  value = module.account_integration.azuread_service_principal_password
}

output "qubole_storage_account_name" {
  value = module.account_integration.qubole_dedicated_storage_account_name
}

output "qubole_defloc" {
  value = "${module.account_integration.qubole_defloc}@${module.account_integration.qubole_dedicated_storage_account_name}.blob.core.windows.net"
}

output "qubole_dedicated_storage_account_key_primary" {
  value = module.account_integration.qubole_dedicated_storage_account_key_primary
}

output "qubole_dedicated_storage_account_key_secondary" {
  value = module.account_integration.qubole_dedicated_storage_account_key_secondary
}


