terraform {
  backend "azurerm" {
    resource_group_name   = "my-rg"
    storage_account_name  = "mt24056terraform"
    container_name        = "tfstatefile"
    key                   = "terraform.tfstate"
  }
}
