terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.33.0"
    }
  }

}
provider "azurerm" {
  features {}
  subscription_id = "a60bfb4b-160f-44e7-979b-775bdd787c90"
}





