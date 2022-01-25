
provider "azurerm" {
    version = ">=2.9.0"
}

# Resources
resource "azurerm_resource_group" "abt" {
    name        = "${var.namePrefix}-rg"
    location    = "${var.region}"

    tags {
        Owner       = "${var.owner}"
        environment = "${var.env}"
    }
}

resource "azurerm_virtual_network" "abt" {
    name                = "${var.namePrefix}-vnet"
    address_space       = ["10.0.0.0/16"]
    location            = "${azurerm_resource_group.abt.location}"
    resource_group_name = "${azurerm_resource_group.abt.name}"

    tags {
        Owner       = "${var.owner}"
        environment = "${var.env}"
    }
}

resource "azurerm_subnet" "abt" {
    name                    = "${var.namePrefix}-subnet"
    resource_group_name     = "${azurerm_resource_group.abt.name}"
    virtual_network_name    = "${azurerm_virtual_network.abt.name}"
    address_prefix          = "10.0.1.0/24"
}

resource "azurerm_network_interface" "abt" {
    name                = "${var.namePrefix}${count.index}-nic"
    location            = "${azurerm_resource_group.abt.location}"
    resource_group_name = "${azurerm_resource_group.abt.name}"
    count               = "${var.vmcount}"

    ip_configuration {
        name                            = "${var.namePrefix}${count.index}-config"
        subnet_id                       = "${azurerm_subnet.abt.id}"
        private_ip_address_allocation   = "dynamic"
        public_ip_address_id            = "${element(azurerm_public_ip.abt.*.id, count.index)}"

    }
}

resource "azurerm_virtual_machine" "abt" {
    name                    = "${var.namePrefix}${count.index}"
    location                = "${azurerm_resource_group.abt.location}"
    resource_group_name     = "${azurerm_resource_group.abt.name}"
    network_interface_ids   = ["${element(azurerm_network_interface.abt.*.id, count.index)}"]
    vm_size                 = "${var.vmSize}"
    count                   = "${var.vmcount}"

    storage_image_reference {
        publisher   = "MicrosoftWindowsServer"
        offer       = "WindowsServer"
        sku         = "2016-Datacenter"
        version     = "latest"
    }

    storage_os_disk {
        name                = "${var.namePrefix}${count.index}-osdisk"
        caching             = "ReadWrite"
        create_option       = "FromImage"
        managed_disk_type   = "Standard_LRS"
    }

    os_profile {
        computer_name       = "${var.namePrefix}${count.index}"
        admin_username      = "${var.username}"
        admin_password      = "${var.pass}"
    }

    os_profile_windows_config {}

    tags {
        Owner       = "${var.owner}"
        environment = "${var.env}"
    }
}

resource "azurerm_public_ip" "abt" {
    name                            = "${var.namePrefix}${count.index}-pubip"
    location                        = "${azurerm_resource_group.abt.location}"
    resource_group_name             = "${azurerm_resource_group.abt.name}"
    allocation_method               = "Static"
    domain_name_label               = "${var.namePrefix}${count.index}"
    count                           = "${var.vmcount}"
}