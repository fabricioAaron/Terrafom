resource "azurerm_resource_group" "example" {
  name     = "${var.environment}-resources"
  location = var.ubicacion_permitida[0] #aquí se asigna la ubicación del recurso utilizando la variable "ubicacion_permitida" que se ha definido en el archivo variables.tf, y se accede al primer elemento de la lista con el índice [0]
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.environment}-network"
  address_space       = [element(var.configuración_network, 0)] #aquí se asigna el espacio de direcciones de la red virtual utilizando la variable "configuración_network" que se ha definido en el archivo variables.tf, y se accede al primer elemento de la tupla con la función element() y el índice 0
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["${element(var.configuración_network, 1)}/${element(var.configuración_network,2)}"] #aquí se asigna el prefijo de direcciones de la subred utilizando la variable "configuración_network" que se ha definido en el archivo variables.tf, y se accede al segundo elemento de la tupla con la función element() y el índice 1, y al tercer elemento de la tupla con la función element() y el índice 2 para obtener el número de IPs privadas
}

resource "azurerm_network_interface" "main" {
  name                = "${var.environment}-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "main" {
  name                  = "${var.environment}-vm"
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = var.sizes_vm[0] #aquí se asigna el tamaño de la máquina virtual utilizando la variable "sizes_vm" que se ha definido en el archivo variables.tf, y se accede al primer elemento del conjunto con el índice [0]

  # Uncomment this line to delete the OS disk automatically when deleting the VM
   delete_os_disk_on_termination = var.vm_delete
  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = var.vm_config.publisher
    offer     = var.vm_config.offer
    sku       = var.vm_config.sku
    version   = var.vm_config.version #aquí se asigna la versión de la imagen de la máquina virtual utilizando la variable "vm_config" que se ha definido en el archivo variables.tf, y se accede al valor de la clave "version" con el índice ["version"]
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    disk_size_gb = var.storage_disk #aquí se añade el espacio del disco de nuesto mv (SO) con la variable "storage_disk" que se ha definido en el archivo variables.tf
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = var.etiqueta_recursos["environment"] #aquí se asigna la etiqueta "environment" utilizando la variable "resources_tags" que se ha definido en el archivo variables.tf, y se accede al valor de la clave "environment" con el índice ["environment"]
    managed_by = var.etiqueta_recursos["managed_by"] 
    department = var.etiqueta_recursos["department"] 
  }
}