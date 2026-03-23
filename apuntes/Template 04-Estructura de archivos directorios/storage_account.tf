resource "azurerm_storage_account" "example" {

  name                     = "template001"
  resource_group_name      = azurerm_resource_group.example.name #aquí se hace referencia al recurso anterior, para que tome el nombre del grupo de recursos creado anteriormente
  location                 = azurerm_resource_group.example.location #sería una dependencia, porque el recurso de la cuenta de almacenamiento depende del grupo de recursos, entonces se hace referencia a la ubicación del grupo de recursos creado anteriormente
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    # environment = var.environment #aquí se hace referencia a la variable creada anteriormente, para que tome el valor de la variable, en este caso el valor por defecto es "staging"
    #envieronment = local.common_tags.stage #aquí se hace referencia a la variable local creada anteriormente, para que tome el valor de la variable local, en este caso el valor es "alpha"
    environment = local.common_tags.environment #aquí se hace referencia a la variable local creada anteriormente, para que tome el valor de la variable local, en este caso el valor es "dev"
  }

  # depends_on = [ azurerm_resource_group.example ] #dependencia explícita, para que se cree el recurso de la cuenta de almacenamiento después de que se haya creado el grupo de recursos

}

