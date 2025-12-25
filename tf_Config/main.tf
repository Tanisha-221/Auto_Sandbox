resource "azurerm_resource_group" "example" {
  name     = "${var.prefix}-resourceGroup"
  location = "West Europe"
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

resource "azurerm_virtual_machine" "vm" {
  count               = var.vm_count
  name                = "${var.prefix}-VM"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  vm_size             = "Standard_B1s"
  #disable_password_authentication = false
  network_interface_ids = [azurerm_network_interface.main[count.index].id]

  os_profile_linux_config {
    disable_password_authentication = false
  }
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1-${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = var.computerName
    admin_username = var.adminUsername
    admin_password = var.adminpassword
  }
}

resource "azurerm_log_analytics_workspace" "la" {
  name                = "sandboxLogAnalytics"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "PerGB2018"
}

resource "azurerm_monitor_diagnostic_setting" "mds" {
  count                      = var.vm_count
  name                       = "mds-diagnostics-setting"
  target_resource_id         = azurerm_virtual_machine.vm[count.index].id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.la.id

  enabled_metric {
    category = "AllMetrics"
  }
}
module "storage_account" {
  source = "./module/storage_account"
}

resource "azurerm_monitor_action_group" "example" {
    name                = "${var.prefix}-action-group"
    resource_group_name = azurerm_resource_group.example.name
    location            = azurerm_resource_group.example.location
    short_name = "notification"

    webhook_receiver {
        name      = "SlackNotification"
        service_uri = var.service_url
  }
}