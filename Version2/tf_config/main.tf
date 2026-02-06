locals {
  current_date = formatdate("YYYY-MM-DD", timestamp())
}

resource "azurerm_resource_group" "example" {
  name     = var.resource_group
  location = "West Europe"

  tags = {
    Environment = "Sandbox"
    CreatedOn   = local.current_date
  }
}