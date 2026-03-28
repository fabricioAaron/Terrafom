output "rgname" {
  value = azurerm_resource_group.example[*].name

}

output "storage_name" {
  value = [for i in azurerm_storage_account.example : i.name] #aquí se utiliza una expresión de comprensión de lista para iterar sobre la lista de cuentas de almacenamiento creadas con el recurso azurerm_storage_account, y se extrae el nombre de cada cuenta de almacenamiento utilizando la variable i.name, y se devuelve una lista con los nombres de todas las cuentas de almacenamiento
}