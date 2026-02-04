locals {
  current_date = formatdate("YYYY-MM-DD", timestamp())
}

resource "azurerm_resource_group" "example" {
  name     = "${var.prefix}-resourceGroup"
  location = "West Europe"
  tags = {
    Environment = "Sandbox"
    CreatedOn   = local.current_date
  }
}

resource "azurerm_virtual_network" "network" {
  name                = "${var.prefix}-Network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.prefix}-internal"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "vm_public_ip" {
  count               = var.vm_count
  name                = "${var.prefix}-public-ip-${count.index}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  allocation_method   = "Static" # You can change to "Static" if you need a static IP.
}

resource "azurerm_network_interface" "main" {
  count               = var.vm_count
  name                = "${var.prefix}-nic-${count.index}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "sandoxipconfig1"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address            = "10.0.1.${count.index + 4}"
    private_ip_address_allocation = "Static"
    public_ip_address_id          = azurerm_public_ip.vm_public_ip[count.index].id
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  count               = var.vm_count
  name                = "${var.prefix}-VM-${count.index}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_B1s"

  admin_username                  = var.adminUsername
  admin_password                  = var.adminpassword
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.main[count.index].id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

resource "azurerm_log_analytics_workspace" "la" {
  name                = "sandboxLogAnalytics"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "PerGB2018"
}

# resource "azurerm_monitor_diagnostic_setting" "mds" {
#   count                      = var.vm_count
#   name                       = "settings-${count.index}"
#   target_resource_id         = azurerm_virtual_machine.vm[count.index].id
#   log_analytics_workspace_id = azurerm_log_analytics_workspace.la.id

#   enabled_metric {
#     category = "AllMetrics"
#   }

#   depends_on = [azurerm_virtual_machine.vm, azurerm_log_analytics_workspace.la]

# }
module "storage_account" {
  source = "./module/storage_account"
}

# resource "azurerm_monitor_action_group" "example" {
#     name                = "${var.prefix}-action-group"
#     resource_group_name = azurerm_resource_group.example.name
#     location            = "Global"
#     short_name = "notification"

#     webhook_receiver {
#         name      = "SlackNotification"
#         service_uri = var.service_url
#   }
# }