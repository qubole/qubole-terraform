resource "azuread_application" "qubole_azure_ad_application" {
  name = "qubole_azure_ad_application_${var.deployment_suffix}"
  homepage = "https://azure.qubole.com"
  available_to_other_tenants = true
  oauth2_allow_implicit_flow = true
  type = "webapp/api"
}

#Generating Client Secrets: https://github.com/terraform-providers/terraform-provider-azuread/issues/95
resource "random_password" "password_for_client" {
  length = 33
  special = true
}

resource "azuread_application_password" "application_password" {
  application_object_id = azuread_application.qubole_azure_ad_application.id
  value = random_password.password_for_client.result
  end_date = timeadd(timestamp(), "8760h")
}

resource "azuread_service_principal" "qubole_azure_ad_application_svc_principal" {
  application_id = azuread_application.qubole_azure_ad_application.application_id

  tags = [
    "qubole_tf_deployed_${var.deployment_suffix}"]

}

resource "azuread_service_principal_password" "service_principal_password" {
  service_principal_id = azuread_service_principal.qubole_azure_ad_application_svc_principal.id
  value = random_password.password_for_client.result
  end_date = timeadd(timestamp(), "8760h")
}

output "qubole_azure_ad_application_id" {
  value = azuread_application.qubole_azure_ad_application.application_id
}

output "qubole_azure_ad_directory_id" {
  value = var.directory_tenant_id
}

output "application_password" {
  value = azuread_application_password.application_password
}

output "service_principal_password" {
  value = azuread_service_principal_password.service_principal_password
}
