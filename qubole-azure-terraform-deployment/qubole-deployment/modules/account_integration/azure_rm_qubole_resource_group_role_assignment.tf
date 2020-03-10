resource "azurerm_role_assignment" "assign_contributor_role_to_qubole_rg" {
  scope              = azurerm_resource_group.qubole_resource_group.id
  role_definition_name = "Contributor"
  principal_id       = azuread_service_principal.qubole_azure_ad_application_svc_principal.id
}