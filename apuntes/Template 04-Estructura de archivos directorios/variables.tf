variable "environment" { #aquí se define una variable llamada "environment", que es de tipo string, y tiene una descripción y un valor por defecto, en este caso el valor por defecto es "staging"
  type = string
  description = "el tipo de entorno"
  default = "staging"
}
