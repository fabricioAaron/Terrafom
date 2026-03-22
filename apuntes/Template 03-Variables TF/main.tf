terraform {
  required_providers { #aquí se definen los proveedores que se van a utilizar, en este caso el proveedor de Azure
    azurerm = {
        source  = "hashicorp/azurerm"
        version = "~> 4.65.0"
        }
  }

  required_version = ">=1.14.0" #aquí se define la versión mínima de terraform que se requiere para ejecutar este código
}

provider "azurerm" { #aquí se configura el proveedor de Azure, en este caso se habilita la característica de "features" que es necesaria para utilizar algunos recursos de Azure
    features {
      
    }
  
}

variable "environment" { #aquí se define una variable llamada "environment", que es de tipo string, y tiene una descripción y un valor por defecto, en este caso el valor por defecto es "staging"
  type = string
  description = "el tipo de entorno"
  default = "staging"
}

locals {
  common_tags = { 
    # environment = var.environment #aquí se hace referencia a la variable creada anteriormente, para que tome el valor de la variable, en este caso el valor por defecto es "staging"
    environment = "dev"
    lob ="IT"
    stage = "alpha"

}
}

#sería el tipo que recurso que quiero aplicar 
resource "azurerm_resource_group" "example" { #lo que esta entre comidas es el nombre del recurso, que es  interno para terraform, no tiene que ser igual al de azure 
  name     = "example-resources"
  location = "Norway East"
}

resource "azurerm_storage_account" "example" {

  name                     = "template001"
  resource_group_name      = azurerm_resource_group.example.name #aquí se hace referencia al recurso anterior, para que tome el nombre del grupo de recursos creado anteriormente
  location                 = azurerm_resource_group.example.location #sería una dependencia, porque el recurso de la cuenta de almacenamiento depende del grupo de recursos, entonces se hace referencia a la ubicación del grupo de recursos creado anteriormente
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    # environment = var.environment #aquí se hace referencia a la variable creada anteriormente, para que tome el valor de la variable, en este caso el valor por defecto es "staging"
    envieronment = local.common_tags.stage #aquí se hace referencia a la variable local creada anteriormente, para que tome el valor de la variable local, en este caso el valor es "alpha"
    environment = local.common_tags.environment #aquí se hace referencia a la variable local creada anteriormente, para que tome el valor de la variable local, en este caso el valor es "dev"
  }
}

output "storage_account_name" {
  value = azurerm_storage_account.example.name #aquí se define una salida llamada "storage_account_name", que es el nombre de la cuenta de almacenamiento creada anteriormente, para que se pueda ver el resultado después de aplicar el código
  
}