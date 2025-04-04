provider "azuread" {}

provider "azurerm" {
  features {}
  subscription_id = "d8d6ad8c-f635-407e-81b9-4ce76f2d5a10"
}

# Create Resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Create Azure AD Users
resource "azuread_user" "owner" {
  user_principal_name    = "owneruser1@turfofficial257gmail.onmicrosoft.com"
  display_name           = "User One"
  mail_nickname          = "user1"
  password               = "StrongPassword@123"
  force_password_change  = false
}

resource "azuread_user" "member2" {
  user_principal_name    = "user2@turfofficial257gmail.onmicrosoft.com"
  display_name           = "User Two"
  mail_nickname          = "user2"
  password               = "StrongPassword@123"
  force_password_change  = false
}

resource "azuread_user" "member3" {
  user_principal_name    = "user3@turfofficial257gmail.onmicrosoft.com"
  display_name           = "User Three"
  mail_nickname          = "user3"
  password               = "StrongPassword@123"
  force_password_change  = false
}

resource "azuread_user" "member4" {
  user_principal_name    = "user4@turfofficial257gmail.onmicrosoft.com"
  display_name           = "User Four"
  mail_nickname          = "user4"
  password               = "StrongPassword@123"
  force_password_change  = false
}

# Azure AD Group
resource "azuread_group" "devops_team" {
  display_name     = "DevOps Team"
  security_enabled = true

  owners  = [azuread_user.owner.object_id]
  members = [
    azuread_user.member2.object_id,
    azuread_user.member3.object_id,
    azuread_user.member4.object_id
  ]
}

# Azure SQL Server
resource "azurerm_mssql_server" "sql_server" {
  name                         = "server-rohan-9876"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = var.admin_password
}

# Azure Storage Account
resource "azurerm_storage_account" "storage" {
  name                     = "stgaccrohan9876"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
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
