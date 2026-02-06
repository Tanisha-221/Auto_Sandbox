locals {
  current_date = formatdate("YYYY-MM-DD", timestamp())
}

resource "azurerm_resource_group" "example" {
  count    = var.rg_count
  name     = "${var.resource_group}-RG-${count.index}"
  location = "West Europe"

  tags = {
    Environment = "Sandbox"
    CreatedOn   = local.current_date
    UserName    = var.username
  }
}