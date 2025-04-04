provider "azurerm" {
  features {}
}

provider "azuread" {}

resource "azuread_group" "devops_team" {
  display_name     = "DevOps Team"
  security_enabled = true
  owners           = ["user1@example.com"]
  members          = ["user2@example.com", "user3@example.com", "user4@example.com"]
}

resource "azurerm_mssql_server" "sql_server" {
  name                         = "my-sql-server-123"
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = var.admin_password
}

resource "azurerm_role_assignment" "sql_role" {
  scope                = azurerm_mssql_server.sql_server.id
  role_definition_name = "Contributor"
  principal_id         = azuread_group.devops_team.id
}

resource "azurerm_storage_account" "storage" {
  name                     = "mystorageaccount123"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_role_assignment" "storage_role" {
  scope                = azurerm_storage_account.storage.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azuread_group.devops_team.id
}
