terraform {
  backend "azurerm" {
    resource_group_name   = "rg-rohan"
    storage_account_name  = "rohancont"
    container_name        = "tfstatefile"
    key                   = "terraform.tfstate"
  }
}
