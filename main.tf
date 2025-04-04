provider "azuread" {}

provider "azurerm" {
  features {}
  subscription_id = "d8d6ad8c-f635-407e-81b9-4ce76f2d5a10"
}

# Lookup users by email to get UUIDs
data "azuread_user" "owner" {
  user_principal_name = "user1@example.com"
}

data "azuread_user" "member2" {
  user_principal_name = "user2@example.com"
}

data "azuread_user" "member3" {
  user_principal_name = "user3@example.com"
}

data "azuread_user" "member4" {
  user_principal_name = "user4@example.com"
}

# Azure AD Group
resource "azuread_group" "devops_team" {
  display_name     = "DevOps Team"
  security_enabled = true

  owners  = [data.azuread_user.owner.id]
  members = [
    data.azuread_user.member2.id,
    data.azuread_user.member3.id,
    data.azuread_user.member4.id
  ]
}

# Azure SQL Server
resource "azurerm_mssql_server" "sql_server" {
  name                         = "my-sql-server-123"
  resource_group_name          = "my-rg"
  location                     = "East US"
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = "Password@123"
}

# Azure Storage Account
resource "azurerm_storage_account" "storage" {
  name                     = "mystorageaccount123"
  resource_group_name      = "my-rg"
  location                 = "East US"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Role assignment: Contributor on SQL Server
resource "azurerm_role_assignment" "sql_role" {
  scope                = azurerm_mssql_server.sql_server.id
  role_definition_name = "Contributor"
  principal_id         = azuread_group.devops_team.id
}

# Role assignment: Storage Blob Data Contributor on Storage Account
resource "azurerm_role_assignment" "storage_role" {
  scope                = azurerm_storage_account.storage.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azuread_group.devops_team.id
}
