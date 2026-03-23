#sería el tipo que recurso que quiero aplicar 
resource "azurerm_resource_group" "example" { #lo que esta entre comidas es el nombre del recurso, que es  interno para terraform, no tiene que ser igual al de azure 
  name     = "example-resources"
  location = "Norway East"
}