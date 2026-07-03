terraform {
  required_version = ">= 1.9.0" # 1.9+ needed for cross-variable validation blocks
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}
