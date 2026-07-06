locals {
  mandatory_tags = {
    environment = var.environment
    region      = var.location
    owner       = var.owner
    managed_by  = "terraform"
  }
}

locals {
  name_prefix = "${var.environment}-${var.location_short}"
  app_subnet  = "apptest"
}

resource "azurerm_resource_group" "this" {
  name     = "rg-${local.name_prefix}"
  location = var.location
  tags     = local.mandatory_tags
}

module "vnet" {
  source = "../../../modules/vnet"

  resource_group_name = azurerm_resource_group.this.name
  location             = var.location
  vnet_name            = "vnet-${local.name_prefix}"
  address_space         = ["10.10.0.0/16"]

  subnets = {
    (local.app_subnet) = {
      address_prefixes = ["10.10.1.0/24"]
      create_nsg        = true
      nsg_rules = [
        {
          name                       = "Allow-SSH-Inbound"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "22"
          # Dev convenience only - tighten to a known IP range for anything
          # beyond a throwaway dev box.
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        }
      ]
    }
  }

  tags = local.mandatory_tags
}

resource "azurerm_public_ip" "vm" {
  name                = "pip-${local.name_prefix}-vm01"
  resource_group_name = azurerm_resource_group.this.name
  location             = var.location
  allocation_method    = "Static"
  sku                  = "Standard"
  tags                 = local.mandatory_tags
}

resource "azurerm_network_interface" "vm" {
  name                = "nic-${local.name_prefix}-vm01"
  resource_group_name = azurerm_resource_group.this.name
  location             = var.location
  tags                 = local.mandatory_tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.vnet.subnet_ids[local.app_subnet]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm.id
  }
}


resource "azurerm_storage_account" "diag" {
  name                     = "st${replace(local.name_prefix, "-", "")}diag"
  resource_group_name      = azurerm_resource_group.this.name
  location                  = var.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  min_tls_version            = "TLS1_2"
  tags                       = local.mandatory_tags
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                   = "vm-${local.name_prefix}-01"
  resource_group_name    = azurerm_resource_group.this.name
  location                = var.location
  size                    = var.vm_size
  admin_username          = var.vm_admin_username
  network_interface_ids   = [azurerm_network_interface.vm.id]
  tags                    = local.mandatory_tags

  admin_ssh_key {
    username   = var.vm_admin_username
    public_key = var.vm_admin_ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.diag.primary_blob_endpoint
  }
}
