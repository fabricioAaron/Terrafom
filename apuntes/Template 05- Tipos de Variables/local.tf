locals {
  common_tags = { 
    # environment = var.environment #aquí se hace referencia a la variable creada anteriormente, para que tome el valor de la variable, en este caso el valor por defecto es "staging"
    environment = var.environment #aquí se hace referencia a la variable creada anteriormente, para que tome el valor de la variable, en este caso el valor por defecto es "staging"
    lob ="IT"
    stage = "alpha"

}
}
