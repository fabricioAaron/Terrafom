resource "azurerm_resource_group" "example" {
  name     = "${var.environment}-resources"
  location = var.ubicacion_permitida[0] #aquí se asigna la ubicación del recurso utilizando la variable "ubicacion_permitida" que se ha definido en el archivo variables.tf, y se accede al primer elemento de la lista con el índice [0]
}

resource "azurerm_storage_account" "example" {
  #count                    = length(var.nombre_storage) #aquí se utiliza la función length() para obtener el número de elementos en la lista "ubicacion_permitida", y se asigna ese número al argumento count para crear una cuenta de almacenamiento por cada ubicación permitida
  #name                     = var.nombre_storage[count.index] #aquí se asigna el nombre de la cuenta de almacenamiento utilizando la variable "nombre_storage" que se ha definido en el archivo variables.tf, y se accede al elemento de la lista con el índice count.index para obtener un nombre diferente para cada cuenta de almacenamiento creada
  for_each = var.for_each_nombre_storage #aquí se utiliza el argumento for_each para iterar sobre el conjunto "for_each_nombre_storage" que se ha definido en el archivo variables.tf, y se asigna cada elemento del conjunto a la variable each.key para crear una cuenta de almacenamiento por cada elemento del conjunto
  name = each.value #aquí se asigna el nombre de la cuenta de almacenamiento utilizando la variable each.value, que representa el valor actual del elemento del conjunto en cada iteración del bucle for_each
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "staging"  
  }
} 