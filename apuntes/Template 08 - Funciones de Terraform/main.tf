locals {
  formatted_name    = lower(replace(var.proyecto_name, " ", "-"))                                        #en esta linea le estamos dizendo que nos reemplace los espacios por guiones de la variable proyecto_name y lo guarde en la variable formatted_name
  merge_tags        = merge(var.default_tags, var.environment_tags)                                      #sirve para fucionar las etiquetas
  storage_formatted = replace(replace(lower(substr(var.storage_account_name, 0, 23)), " ", ""), "!", "") #sirve para corta los primeros 23 caracteres de la variable storage_account_name y lo guarda en la variable storage_formatted

  formatted_ports = split(",", (var.allowed_ports))
  nsg_rules = [for port in local.formatted_ports : {
    name        = "port-${port}"
    port        = port
    description = " allowed traffic on port : ${port}"
    }
  ]
}

resource "azurerm_resource_group" "rg" {
  name     = "${local.formatted_name}-rg" #lo que esta entre ${} es para llamar a una variable o a una función y luego se puede concatenar
  location = "spain central"
  tags     = local.merge_tags #aqui estamos usando el merge de las etiquetas
}

resource "azurerm_storage_account" "example" {

  name                     = local.storage_formatted #llamamos a la variable local.storage_formatted 
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = local.merge_tags #aca usamos el merge_tags para que se guarden las etiquetas
}

resource "azurerm_network_security_group" "rg" {
  name                = "${local.formatted_name}-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  dynamic "security_rule" {    #aquí se define un bloque dinámico que se va a ejecutar para cada elemento del mapa de reglas de seguridad siempre que va un dynamic se tiene que poner un content para definir el bloque que se va a ejecutarº
    for_each = local.nsg_rules #esto sirve para iterar cada uno de los elementos que tenemos en el local
    content {
      name                       = security_rule.key        #aqui se define el nombre de la regla dentro de local sería nuestro allow-http, allow-https
      priority                   = 100                      #aqui se define la prioridad de la regla es un mapa anidado
      direction                  = "Inbound"                #aqui se define la dirección de la regla
      access                     = "Allow"                  #aqui se define el acceso de la regla
      protocol                   = "Tcp"                    #aqui se define el protocolo de la regla
      source_port_range          = "*"                      #aqui se define el puerto de origen de la regla
      destination_port_range     = security_rule.value.port #aqui se define el puerto de destino de la regla
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      description                = security_rule.value.description
    }
  }

  tags = {
    environment = "Production"
  }
}

output "rgname" {
  value = azurerm_resource_group.rg.name
}

output "storage_name" {
  value = azurerm_storage_account.example.name
}


output "nsg" {
  value = local.nsg_rules
}

output "security_name" {
  value = azurerm_network_security_group.rg.name
}
