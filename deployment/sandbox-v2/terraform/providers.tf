provider "azurerm" {
  # The "feature" block is required for AzureRM provider 2.x.
  # If you are using version 1.x, the "features" block is not allowed.
  version = "~>2.0"
  features {
  }

  subscription_id = var.subscription_id
  #  TENANT_ID    ="${var.TENANT_ID}"
  #  CLIENT_ID    ="${var.CLIENT_ID}"
  #  CLIENT_SECRET        ="${var.CLIENT_SECRET}"
}
